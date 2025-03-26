/**
 * @Author: Sun Rising
 * @Date: 2024-06-13 09:13:13
 * @Last Modified by: Sun Rising
 * @Last Modified time: 2024-12-08 09:56:15
 * @Description: 生成播放清单 playlists.json
 * node .\generate-playlists.js "E:\CodeRepository\Gitee\bible-player\附录\圣经"
 */
const path = require("node:path");
const fs = require("node:fs/promises");

(async () => {
  let resourceDir = process.argv[2];
  if (!resourceDir) {
    resourceDir = path.join(__dirname, "./");
  }

  let playlists = [];
  const files = (await fs.readdir(resourceDir)).sort(
    (a, b) => getUnicode(a) - getUnicode(b)
  );
  for (let index = 0; index < files.length; index++) {
    const file = files[index];
    const chapterPath = path.join(resourceDir, file);
    if ((await fs.stat(chapterPath)).isDirectory()) {
      let playlist = {
        title: file,
        id: index + "",
        chapters: [],
      };
      playlists.push(playlist);
      // 寻找章
      const chapterFiles = (await fs.readdir(chapterPath)).sort(
        (a, b) => getUnicode(a) - getUnicode(b)
      );
      for (let index2 = 0; index2 < chapterFiles.length; index2++) {
        const chapterFile = chapterFiles[index2];
        const sectionPath = path.join(chapterPath, chapterFile);
        if ((await fs.stat(sectionPath)).isDirectory()) {
          const chapter = {
            name: chapterFile,
            id: index + "_" + index2,
            sections: [],
          };
          playlist.chapters.push(chapter);
          // 寻找节
          const sectionFiles = (await fs.readdir(sectionPath)).sort(
            (a, b) => getUnicode(a) - getUnicode(b)
          );
          for (let index3 = 0; index3 < sectionFiles.length; index3++) {
            const audioFile = sectionFiles[index3];
            const audioFilePath = path.join(sectionPath, audioFile);
            if (path.parse(audioFilePath).ext == ".mp3") {
              chapter.sections.push({
                name: path.parse(audioFile).name,
                id: index + "_" + index2 + "_" + index3,
                url: audioFilePath.replace(resourceDir, ""),
                subtitle: `${file}/${chapterFile}`
              });
            }
          }
        }
      }
    }
  }

  fs.writeFile(
    path.join(resourceDir, "playlists.json"),
    JSON.stringify(playlists, null, 2)
  );
})();

function getUnicode(str) {
  return str
    .split("")
    .map((value) => value.charCodeAt())
    .join("");
}
