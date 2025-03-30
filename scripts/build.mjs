import { parse } from "yaml";
import { join, dirname } from "node:path";
import { fileURLToPath } from "url";
import { readFileSync } from "fs";
import semver from "semver";
import { Command } from "commander";
import moment from "moment";
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readdirSync,
  writeFileSync,
} from "node:fs";
import { exec } from "node:child_process";
import { promisify } from "node:util";
import fs from "fs-extra";
const execPromess = promisify(exec);

const __filenameNew = fileURLToPath(import.meta.url);
const __dirnameNew = dirname(__filenameNew);

const pubspecPath = join(__dirnameNew, "../pubspec.yaml");
const outPutDir = join(__dirnameNew, "../dist/");
const flutterOutPutDir = join(
  __dirnameNew,
  "../build/app/outputs/apk/release/"
);
const releaseDataFileName = "release-data.json";

const program = new Command();
program
  .option("-x, --major")
  .option("-y, --minor")
  .option("-z, --patch")
  .action(run);

program.parse();

async function run(option) {
  let pubspecStrCopy;
  try {
    let pubspecStr = readFileSync(pubspecPath, "utf8");
    pubspecStrCopy = pubspecStr;
    const pubspec = parse(pubspecStr);
    const versionArr = pubspec.version.split("+");
    // major.minor.patch
    let nextVersion;
    if (option.major) {
      nextVersion = semver.inc(versionArr[0], "major");
    } else if (option.minor) {
      nextVersion = semver.inc(versionArr[0], "minor");
    } else {
      nextVersion = semver.inc(versionArr[0], "patch");
    }
    pubspecStr = pubspecStr.replace(
      pubspec.version,
      [nextVersion, versionArr[1]].join("+")
    );
    writeFileSync(pubspecPath, pubspecStr, {
      encoding: "utf8",
    });
    console.log(`开始构建新版本：${nextVersion}，请稍等...`);

    //
    await execPromess(`flutter build apk --release`, {
      cwd: join(__dirnameNew, "../"),
    });
    const filesName = readdirSync(flutterOutPutDir);
    const apkFileName = filesName.find((name) => name.includes(".apk"));
    const packageDir = join(outPutDir, `v${nextVersion}/`);
    if (existsSync(packageDir)) {
      fs.removeSync(packageDir)
    }
    mkdirSync(packageDir);
    copyFileSync(
      join(flutterOutPutDir, apkFileName),
      join(packageDir, apkFileName)
    );
    //
    const releaseData = {
      lastVersion: versionArr[0],
      version: nextVersion,
      fileName: apkFileName,
      time: moment().format("YYYY-MM-DD"),
      upgradeInstructions: ["修复已知问题"],
    };
    fs.writeJSONSync(join(packageDir, releaseDataFileName), releaseData, {
      encoding: "utf8",
      spaces: 2,
    });
    console.log(releaseData);
    console.log(`构建完成！！`);
  } catch (error) {
    console.error(error);
    writeFileSync(pubspecPath, pubspecStrCopy, {
      encoding: "utf8",
    });
  }
}
