#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
圣经音频爬虫
下载 https://www.wordproaudio.net 的中文圣经音频
"""

import os
import time
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
from threading import Lock

# 配置
BASE_URL = "https://www.wordproaudio.net/bibles/app/audio/4/{book}/{chapter}.mp3"
SAVE_DIR = r"E:\CodeRepository\GitHub\bible-player\附件\new"
DELAY = 2  # 秒
MAX_WORKERS = 3  # 并行线程数

# 圣经书卷信息 (编号, 中文名, 章节数)
OLD_TESTAMENT = [
    (1, "创世记", 50), (2, "出埃及记", 40), (3, "利未记", 27), (4, "民数记", 36), (5, "申命记", 34),
    (6, "约书亚记", 24), (7, "士师记", 21), (8, "路得记", 4), (9, "撒母耳记上", 31),
    (10, "撒母耳记下", 24), (11, "列王纪上", 22), (12, "列王纪下", 25), (13, "历代志上", 29),
    (14, "历代志下", 36), (15, "以斯拉记", 10), (16, "尼希米记", 13), (17, "以斯帖记", 10),
    (18, "约伯记", 42), (19, "诗篇", 150), (20, "箴言", 31), (21, "传道书", 12),
    (22, "雅歌", 8), (23, "以赛亚书", 66), (24, "耶利米书", 52), (25, "耶利米哀歌", 5),
    (26, "以西结书", 48), (27, "但以理书", 12), (28, "何西阿书", 14), (29, "约珥书", 3),
    (30, "阿摩司书", 9), (31, "俄巴底亚书", 1), (32, "约拿书", 4), (33, "弥迦书", 7),
    (34, "那鸿书", 3), (35, "哈巴谷书", 3), (36, "西番雅书", 3), (37, "哈该书", 2),
    (38, "撒迦利亚书", 14), (39, "玛拉基书", 4)
]

NEW_TESTAMENT = [
    (40, "马太福音", 28), (41, "马可福音", 16), (42, "路加福音", 24), (43, "约翰福音", 21),
    (44, "使徒行传", 28), (45, "罗马书", 16), (46, "哥林多前书", 16), (47, "哥林多后书", 13),
    (48, "加拉太书", 6), (49, "以弗所书", 6), (50, "腓立比书", 4), (51, "歌罗西书", 4),
    (52, "帖撒罗尼迦前书", 5), (53, "帖撒罗尼迦后书", 3), (54, "提摩太前书", 6), (55, "提摩太后书", 4),
    (56, "提多书", 3), (57, "腓利门书", 1), (58, "希伯来书", 13), (59, "雅各书", 5),
    (60, "彼得前书", 5), (61, "彼得后书", 3), (62, "约翰一书", 5), (63, "约翰二书", 1),
    (64, "约翰三书", 1), (65, "犹大书", 1), (66, "启示录", 22)
]

# 请求头
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": "https://www.wordproject.org/"
}

# 统计
stats = {"success": 0, "failed": 0, "skipped": 0}
stats_lock = Lock()


def download_one(book_num, chapter, book_name):
    """下载单个音频文件"""
    filename = f"{book_num:02d}_{book_name}_{chapter:03d}.mp3"
    filepath = os.path.join(SAVE_DIR, filename)
    url = BASE_URL.format(book=book_num, chapter=chapter)

    # 跳过已存在的文件
    if os.path.exists(filepath):
        with stats_lock:
            stats["skipped"] += 1
        print(f"[跳过] {filename} (已存在)")
        return True

    try:
        response = requests.get(url, headers=HEADERS, timeout=30)
        if response.status_code == 200:
            with open(filepath, 'wb') as f:
                f.write(response.content)
            with stats_lock:
                stats["success"] += 1
            print(f"[成功] {filename}")
            return True
        else:
            with stats_lock:
                stats["failed"] += 1
            print(f"[失败] {filename} (HTTP {response.status_code})")
            return False
    except Exception as e:
        with stats_lock:
            stats["failed"] += 1
        print(f"[错误] {filename}: {e}")
        return False


def main():
    # 创建保存目录
    os.makedirs(SAVE_DIR, exist_ok=True)

    # 构建所有任务
    tasks = []
    for book_num, book_name, chapters in OLD_TESTAMENT + NEW_TESTAMENT:
        for chapter in range(1, chapters + 1):
            tasks.append((book_num, chapter, book_name))

    total = len(tasks)
    print(f"共计 {total} 个音频文件")
    print(f"保存目录: {SAVE_DIR}")
    print(f"下载间隔: {DELAY} 秒")
    print("-" * 50)

    # 使用线程池下载
    completed = 0
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {}
        for book_num, chapter, book_name in tasks:
            future = executor.submit(download_one, book_num, chapter, book_name)
            futures[future] = (book_num, chapter, book_name)
            time.sleep(0.1)  # 稍微延迟提交，避免瞬间太多请求

        for future in as_completed(futures):
            completed += 1
            if completed % 50 == 0:
                print(f"\n进度: {completed}/{total}")
            time.sleep(DELAY)  # 下载间隔

    # 输出统计
    print("\n" + "=" * 50)
    print(f"下载完成!")
    print(f"成功: {stats['success']}")
    print(f"失败: {stats['failed']}")
    print(f"跳过: {stats['skipped']}")
    print(f"总计: {total}")


if __name__ == "__main__":
    main()