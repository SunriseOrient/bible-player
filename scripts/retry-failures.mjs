import fs from 'fs-extra';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import https from 'https';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const FAILURE_LOG_PATH = path.join(__dirname, 'fetch-scripture-failures.log');
const NEW_FAILURE_LOG_PATH = path.join(__dirname, 'fetch-scripture-failures-new.log');

// 简体转繁体映射表（旧约 + 新约）
const SIMPLIFIED_TO_TRADITIONAL = {
  // 旧约
  '创世记': '創世記',
  '出埃及记': '出埃及記',
  '利未记': '利未記',
  '民数记': '民數記',
  '申命记': '申命記',
  '约书亚记': '約書亞記',
  '士师记': '士師記',
  '路得记': '路得記',
  '撒母耳记上': '撒母耳記上',
  '撒母耳记下': '撒母耳記下',
  '列王纪上': '列王紀上',
  '列王纪下': '列王紀下',
  '历代志上': '歷代志上',
  '历代志下': '歷代志下',
  '以斯拉记': '以斯拉記',
  '尼希米记': '尼希米記',
  '以斯帖记': '以斯帖記',
  '约伯记': '約伯記',
  '诗篇': '詩篇',
  '箴言': '箴言',
  '传道书': '傳道書',
  '雅歌': '雅歌',
  '以赛亚书': '以賽亞書',
  '耶利米书': '耶利米書',
  '耶利米哀歌': '耶利米哀歌',
  '以西结书': '以西結書',
  '但以理书': '但以理書',
  '何西阿书': '何西阿書',
  '约珥书': '約珥書',
  '阿摩司书': '阿摩司書',
  '俄巴底亚书': '俄巴底亞書',
  '约拿书': '約拿書',
  '弥迦书': '彌迦書',
  '那鸿书': '那鴻書',
  '哈巴谷书': '哈巴谷書',
  '西番雅书': '西番雅書',
  '哈该书': '哈該書',
  '撒迦利亚书': '撒迦利亞書',
  '玛拉基书': '瑪拉基書',

  // 新约
  '马太福音': '馬太福音',
  '马可福音': '馬可福音',
  '路加福音': '路加福音',
  '约翰福音': '約翰福音',
  '使徒行传': '使徒行傳',
  '罗马书': '羅馬書',
  '哥林多前书': '哥林多前書',
  '哥林多后书': '哥林多後書',
  '加拉太书': '加拉太書',
  '以弗所书': '以弗所書',
  '腓立比书': '腓立比書',
  '歌罗西书': '歌羅西書',
  '帖撒罗尼迦前书': '帖撒羅尼迦前書',
  '帖撒罗尼迦后书': '帖撒羅尼迦後書',
  '提摩太前书': '提摩太前書',
  '提摩太后书': '提摩太後書',
  '提多书': '提多書',
  '腓利门书': '腓利門書',
  '希伯来书': '希伯來書',
  '雅各书': '雅各書',
  '彼得前书': '彼得前書',
  '彼得后书': '彼得後書',
  '约翰一书': '約翰一書',
  '约翰二书': '約翰二書',
  '约翰三书': '約翰三書',
  '犹大书': '猶大書',
  '启示录': '啟示錄'
};

/**
 * 将简体中文书名转换为繁体中文
 */
function convertToTraditional(bookName) {
  return SIMPLIFIED_TO_TRADITIONAL[bookName] || bookName;
}

/**
 * 从文件路径中提取书卷名和章节号
 * 例如: "E:\...\约翰福音\约翰福音-第3章.txt" -> { book: '约翰福音', chapter: '3' }
 */
function parseFilePath(filePath) {
  const filename = path.basename(filePath);
  const match = filename.match(/^(.+?)-第(\d+)章\.txt$/);
  if (match) {
    return {
      book: match[1],
      chapter: match[2]
    };
  }
  return null;
}

/**
 * 从 Bible API 获取经文内容
 */
async function fetchScriptureFromAPI(bookName, chapter) {
  const traditionalName = convertToTraditional(bookName);
  const url = `https://bible-api.com/${encodeURIComponent(traditionalName)}+${chapter}?translation=cuv`;
  
  console.log(`正在获取: ${url}`);
  
  return new Promise((resolve) => {
    https.get(url, (res) => {
      let data = '';
      
      res.on('data', chunk => {
        data += chunk;
      });
      
      res.on('end', () => {
        try {
          const jsonData = JSON.parse(data);
          resolve(jsonData.text || null);
        } catch (e) {
          console.error(`解析 JSON 失败:`, e.message);
          resolve(null);
        }
      });
    }).on('error', (error) => {
      console.error(`获取经文失败 - ${bookName} 第 ${chapter} 章:`, error.message);
      resolve(null);
    });
  });
}

/**
 * 带重试的获取经文
 */
async function fetchScriptureWithRetry(bookName, chapter, maxRetries = 5) {
  for (let attempt = 1; attempt <= maxRetries; attempt += 1) {
    const text = await fetchScriptureFromAPI(bookName, chapter);
    if (text) return text;

    console.warn(`  尝试 ${attempt}/${maxRetries} 失败: ${bookName} 第 ${chapter} 章`);
    if (attempt < maxRetries) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  return null;
}

/**
 * 重试失败的经文获取
 */
async function retryFailures() {
  console.log('开始重试失败的项...\n');
  
  // 检查失败日志是否存在
  if (!(await fs.pathExists(FAILURE_LOG_PATH))) {
    console.log('未找到失败日志文件');
    return;
  }

  // 读取失败日志
  const content = await fs.readFile(FAILURE_LOG_PATH, 'utf-8');
  const failedPaths = content.trim().split('\n').filter(line => line.trim());
  
  if (failedPaths.length === 0) {
    console.log('没有需要重试的项');
    return;
  }

  console.log(`找到 ${failedPaths.length} 个失败的项\n`);

  // 清空新的失败日志
  await fs.writeFile(NEW_FAILURE_LOG_PATH, '', 'utf-8');

  let successCount = 0;
  let failCount = 0;

  for (const filePath of failedPaths) {
    const parsed = parseFilePath(filePath);
    if (!parsed) {
      console.log(`无法解析路径: ${filePath}`);
      await fs.appendFile(NEW_FAILURE_LOG_PATH, `${filePath}\n`, 'utf-8');
      failCount++;
      continue;
    }

    const { book, chapter } = parsed;
    console.log(`\n处理: ${book} 第 ${chapter} 章`);

    // 检查文件是否已存在
    if (await fs.pathExists(filePath)) {
      console.log(`  跳过: 文件已存在`);
      continue;
    }

    // 重试获取经文
    const scriptureText = await fetchScriptureWithRetry(book, chapter, 5);

    if (scriptureText) {
      await fs.writeFile(filePath, scriptureText, 'utf-8');
      console.log(`  ✓ 成功创建`);
      successCount++;
    } else {
      console.log(`  ✗ 仍然失败`);
      await fs.appendFile(NEW_FAILURE_LOG_PATH, `${filePath}\n`, 'utf-8');
      failCount++;
    }

    // 延迟以避免 API 频率限制
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  console.log(`\n\n=== 重试完成 ===`);
  console.log(`成功: ${successCount}`);
  console.log(`失败: ${failCount}`);
  console.log(`新的失败日志: ${NEW_FAILURE_LOG_PATH}`);

  // 如果没有失败项，删除新的失败日志
  if (failCount === 0) {
    await fs.remove(NEW_FAILURE_LOG_PATH);
    console.log('所有项目已成功，已删除新的失败日志');
  }
}

// 运行重试
retryFailures().catch(error => {
  console.error('发生错误:', error);
  process.exit(1);
});
