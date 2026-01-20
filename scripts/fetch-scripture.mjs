import fs from 'fs-extra';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import https from 'https';
import http from 'http';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// 简体转繁体映射表
const SIMPLIFIED_TO_TRADITIONAL = {
  '约翰福音': '約翰福音',
  '彼得后书': '彼得後書',
  '彼得前书': '彼得前書',
  '约翰一书': '約翰一書',
  '约翰二书': '約翰二書',
  '约翰三书': '約翰三書',
  '马太福音': '馬太福音',
  '路加福音': '路加福音',
  '马可福音': '馬可福音',
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
  '提摩太后书': '提摩太後書',
  '提多书': '提多書',
  '腓利门书': '腓利門書',
  '希伯来书': '希伯來書',
  '雅各书': '雅各書',
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
 * 从文件名中提取章节号
 * 例如: "约翰福音-第3章.mp3" -> 3
 */
function extractChapterNumber(filename) {
  const match = filename.match(/第(\d+)章/);
  return match ? match[1] : null;
}

/**
 * 从 Bible API 获取经文内容
 */
async function fetchScriptureFromAPI(bookName, chapter) {
  const traditionalName = convertToTraditional(bookName);
  const url = `https://bible-api.com/${traditionalName}+${chapter}?translation=cuv`;
  
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
 * 主函数：遍历目录并生成文本文件
 */
async function generateScriptureTextFiles() {
  const baseDir = path.join(__dirname, '../附件/远程数据/assets/新约全书');
  
  console.log(`开始扫描目录: ${baseDir}\n`);
  
  try {
    // 读取所有书卷目录
    const books = await fs.readdir(baseDir);
    
    for (const book of books) {
      const bookPath = path.join(baseDir, book);
      const stat = await fs.stat(bookPath);
      
      if (!stat.isDirectory()) continue;
      
      console.log(`\n处理书卷: ${book}`);
      
      // 读取书卷目录中的所有MP3文件
      const files = await fs.readdir(bookPath);
      const mp3Files = files.filter(f => f.endsWith('.mp3'));
      
      console.log(`  找到 ${mp3Files.length} 个MP3文件`);
      
      for (const mp3File of mp3Files) {
        const chapterNum = extractChapterNumber(mp3File);
        if (!chapterNum) {
          console.log(`  警告: 无法从文件名提取章节号 - ${mp3File}`);
          continue;
        }
        
        const txtFileName = mp3File.replace(/\.mp3$/, '.txt');
        const txtFilePath = path.join(bookPath, txtFileName);
        
        // 检查文本文件是否已存在
        if (await fs.pathExists(txtFilePath)) {
          console.log(`  跳过: ${txtFileName} (已存在)`);
          continue;
        }
        
        // 从 API 获取经文内容
        const scriptureText = await fetchScriptureFromAPI(book, chapterNum);
        
        if (scriptureText) {
          await fs.writeFile(txtFilePath, scriptureText, 'utf-8');
          console.log(`  ✓ 创建: ${txtFileName}`);
        } else {
          console.log(`  ✗ 失败: ${txtFileName}`);
        }
        
        // 延迟以避免 API 频率限制
        await new Promise(resolve => setTimeout(resolve, 500));
      }
    }
    
    console.log('\n✓ 处理完成！');
  } catch (error) {
    console.error('发生错误:', error);
    process.exit(1);
  }
}

/**
 * 测试函数：获取单个章节的文本
 */
async function testFetchSingleChapter() {
  console.log('=== 测试获取单个章节 ===\n');
  
  // 测试约翰福音第3章
  const bookName = '约翰福音';
  const chapter = '3';
  
  const text = await fetchScriptureFromAPI(bookName, chapter);
  if (text) {
    console.log(`\n成功获取 ${bookName} 第 ${chapter} 章:\n`);
    console.log(text);
  } else {
    console.log('获取失败');
  }
}

// 检查命令行参数
const args = process.argv.slice(2);
if (args.includes('--test')) {
  testFetchSingleChapter();
} else {
  generateScriptureTextFiles();
}
