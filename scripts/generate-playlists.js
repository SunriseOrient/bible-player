const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, '../附件/远程数据/assets');
const outputPath = path.join(__dirname, '../dist/assets/playlists.json');
const URL_PREFIX = process.env.URL_PREFIX || 'https://sunrise.ink:14070/file_store/blble-player/'; // 从环境变量读取前缀，默认为空

function readJsonFile(filePath) {
  try {
    const buffer = fs.readFileSync(filePath);
    let content = buffer.toString('utf-8');
    
    // 如果UTF-8解析失败，尝试UTF-16LE
    if (content.includes('�') || content.includes('\0')) {
      content = buffer.toString('utf-16le');
    }
    
    // 移除BOM
    if (content.charCodeAt(0) === 0xFEFF) {
      content = content.substring(1);
    }
    
    return JSON.parse(content);
  } catch (error) {
    console.error(`读取文件出错 ${filePath}:`, error.message);
    return null;
  }
}

// 将中文数字转换为阿拉伯数字
function chineseToNumber(str) {
  const chineseNum = {
    '零': 0, '一': 1, '二': 2, '三': 3, '四': 4,
    '五': 5, '六': 6, '七': 7, '八': 8, '九': 9,
    '十': 10, '百': 100, '千': 1000, '万': 10000
  };
  
  // 提取"第X章"格式中的中文数字部分
  const match = str.match(/第([零一二三四五六七八九十百千万]+)章/);
  if (!match) return null;
  
  const chinese = match[1];
  let result = 0;
  let temp = 0;
  let unit = 1;
  
  for (let i = chinese.length - 1; i >= 0; i--) {
    const char = chinese[i];
    const num = chineseNum[char];
    
    if (num >= 10) {
      if (num > unit) {
        unit = num;
        if (temp === 0) temp = 1;
      }
    } else {
      temp = num;
    }
    
    if (i === 0 || chineseNum[chinese[i - 1]] >= 10) {
      result += temp * unit;
      temp = 0;
    }
  }
  
  return result;
}

// 从名称中提取数字（支持阿拉伯数字和中文数字）
function extractNumber(name) {
  // 先尝试提取阿拉伯数字
  const arabicMatch = name.match(/第?(\d+)章?/);
  if (arabicMatch) {
    return parseInt(arabicMatch[1]);
  }
  
  // 尝试提取中文数字
  const chineseNum = chineseToNumber(name);
  if (chineseNum !== null) {
    return chineseNum;
  }
  
  // 如果都没有，尝试提取任何数字
  const anyNum = name.match(/\d+/);
  return anyNum ? parseInt(anyNum[0]) : 0;
}

function generatePlaylists() {
  const rootSortConfig = readJsonFile(path.join(dataDir, 'sort_config.json')) || [];
  const playlists = [];

  rootSortConfig.forEach((category, categoryIndex) => {
    const categoryPath = path.join(dataDir, category.folder);
    const categorySortConfig = readJsonFile(path.join(categoryPath, 'sort_config.json')) || [];

    const chapters = [];

    categorySortConfig.forEach((chapter, chapterIndex) => {
      const chapterPath = path.join(categoryPath, chapter.folder);
      
      if (!fs.existsSync(chapterPath)) {
        console.warn(`警告: ${chapterPath} 不存在，跳过...`);
        return;
      }

      const chapterConfig = readJsonFile(path.join(chapterPath, 'config.json')) || {};

      const sections = [];
      
      // 检查cover.png是否存在
      const coverPath = path.join(chapterPath, 'cover.png');
      const hasCover = fs.existsSync(coverPath);
      const relativePath = path.relative(path.dirname(dataDir), chapterPath);
      const urlPath = relativePath.split(path.sep).join('/');
      const coverUrl = hasCover ? (URL_PREFIX ? `${URL_PREFIX}${urlPath}/cover.png` : `${urlPath}/cover.png`) : '';

      const files = fs.readdirSync(chapterPath).filter(file => {
        const ext = path.extname(file).toLowerCase();
        return ['.mp3', '.m4a', '.flac', '.wav', '.aac'].includes(ext);
      });
      files.sort();

      files.forEach((file, fileIndex) => {
        const baseName = path.basename(file, path.extname(file));
        const fullUrl = URL_PREFIX ? `${URL_PREFIX}${urlPath}/${file}` : `${urlPath}/${file}`;
        sections.push({
          name: baseName,
          id: `${categoryIndex}_${chapterIndex}_${fileIndex}`,
          url: fullUrl,
          subtitle: `${category.folder}/${chapter.folder}`
        });
      });

      // 对sections进行升序排列（支持阿拉伯数字和中文数字）
      sections.sort((a, b) => {
        const numA = extractNumber(a.name);
        const numB = extractNumber(b.name);
        return numA - numB; // 升序
      });

      // 根据排序后的顺序重新分配连续的id，确保与顺序一致
      sections.forEach((section, sortedIndex) => {
        section.id = `${categoryIndex}_${chapterIndex}_${sortedIndex}`;
      });

      chapters.push({
        name: chapter.name,
        id: `${categoryIndex}_${chapterIndex}`,
        desc: chapterConfig.desc || '',
        icon: chapterConfig.iconName || '',
        coverUrl: coverUrl,
        sections: sections
      });
    });

    playlists.push({
      title: category.name,
      id: String(categoryIndex),
      chapters: chapters
    });
  });

  // 确保输出目录存在
  const outputDir = path.dirname(outputPath);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
    console.log(`已创建目录: ${outputDir}`);
  }

  fs.writeFileSync(outputPath, JSON.stringify(playlists, null, 2), 'utf-8');
  console.log(`已生成 playlists.json 文件于 ${outputPath}`);
}

generatePlaylists();
