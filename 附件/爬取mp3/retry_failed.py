#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""重试失败文件"""

import os
import time
import requests

BASE_URL = "https://www.wordproaudio.net/bibles/app/audio/4/{book}/{chapter}.mp3"
SAVE_DIR = r"E:\CodeRepository\GitHub\bible-player\附件\new"
DELAY = 2

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "Referer": "https://www.wordproject.org/"
}

failed_files = [
    (19, 130, "诗篇"),   # 19_诗篇_130.mp3
    (45, 4, "罗马书"),   # 45_罗马书_004.mp3
]

for book_num, chapter, book_name in failed_files:
    filename = f"{book_num:02d}_{book_name}_{chapter:03d}.mp3"
    filepath = os.path.join(SAVE_DIR, filename)
    url = BASE_URL.format(book=book_num, chapter=chapter)

    print(f"正在下载: {filename}")
    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        if response.status_code == 200:
            with open(filepath, 'wb') as f:
                f.write(response.content)
            print(f"  [成功] {filename}")
        else:
            print(f"  [失败] HTTP {response.status_code}")
    except Exception as e:
        print(f"  [错误] {e}")

    time.sleep(DELAY)

print("\n完成!")