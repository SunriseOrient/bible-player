const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, '../附件/远程数据/assets');
const outputPath = path.join(__dirname, '../dist/assets/playlists.json');
const URL_PREFIX = process.env.URL_PREFIX || 'https://sunrise666.top:14070/file_store/blble-player/'; // 从环境变量读取前缀，默认为空

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
          name: file,
          id: `${categoryIndex}_${chapterIndex}_${fileIndex}`,
          url: fullUrl,
          subtitle: `${category.folder}/${chapter.folder}`
        });
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
