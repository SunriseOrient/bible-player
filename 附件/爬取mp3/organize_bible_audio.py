#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""整理圣经音频文件到正确目录"""

import os
import shutil

SOURCE_DIR = r"E:\CodeRepository\GitHub\bible-player\附件\new"
ASSETS_DIR = r"E:\CodeRepository\GitHub\bible-player\附件\远程数据\assets"

# 旧约书卷
OLD_TESTAMENT = [
    "创世记", "出埃及记", "利未记", "民数记", "申命记", "约书亚记", "士师记", "路得记",
    "撒母耳记上", "撒母耳记下", "列王纪上", "列王纪下", "历代志上", "历代志下",
    "以斯拉记", "尼希米记", "以斯帖记", "约伯记", "诗篇", "箴言", "传道书", "雅歌",
    "以赛亚书", "耶利米书", "耶利米哀歌", "以西结书", "但以理书", "何西阿书",
    "约珥书", "阿摩司书", "俄巴底亚书", "约拿书", "弥迦书", "那鸿书", "哈巴谷书",
    "西番雅书", "哈该书", "撒迦利亚书", "玛拉基书"
]

# 新约书卷
NEW_TESTAMENT = [
    "马太福音", "马可福音", "路加福音", "约翰福音", "使徒行传", "罗马书",
    "哥林多前书", "哥林多后书", "加拉太书", "以弗所书", "腓立比书", "歌罗西书",
    "帖撒罗尼迦前书", "帖撒罗尼迦后书", "提摩太前书", "提摩太后书", "提多书",
    "腓利门书", "希伯来书", "雅各书", "彼得前书", "彼得后书", "约翰一书",
    "约翰二书", "约翰三书", "犹大书", "启示录"
]

moved = 0
failed = 0

for filename in os.listdir(SOURCE_DIR):
    if not filename.endswith(".mp3"):
        continue

    # 解析文件名: 19_诗篇_130.mp3
    try:
        parts = filename.replace(".mp3", "").split("_")
        book_num = int(parts[0])
        book_name = parts[1]
        chapter = int(parts[2])

        # 确定是旧约还是新约
        if book_name in OLD_TESTAMENT:
            target_dir = os.path.join(ASSETS_DIR, "旧约全书", book_name)
        elif book_name in NEW_TESTAMENT:
            target_dir = os.path.join(ASSETS_DIR, "新约全书", book_name)
        else:
            print(f"[未知书卷] {filename}")
            failed += 1
            continue

        os.makedirs(target_dir, exist_ok=True)

        # 生成目标文件名: 诗篇-第130章.mp3
        target_filename = f"{book_name}-第{chapter}章.mp3"
        target_path = os.path.join(target_dir, target_filename)

        # 如果目标已存在则覆盖
        if os.path.exists(target_path):
            os.remove(target_path)

        source_path = os.path.join(SOURCE_DIR, filename)
        shutil.move(source_path, target_path)
        print(f"[移动] {filename} -> {book_name}/{target_filename}")
        moved += 1

    except Exception as e:
        print(f"[错误] {filename}: {e}")
        failed += 1

print(f"\n完成! 移动: {moved}, 失败: {failed}")