#!/bin/bash

# 输出当前时间
echo "当前时间：$(date)"

# 切换到目标目录
cd /var/www/
echo "已切换到目录：$(pwd)"

# 仓库URL
repo_url="https://github.com/your/repository.git"

# 获取仓库名
repo_name=$(basename $repo_url .git)

# 检查仓库是否已存在
if [ -d "$repo_name" ]; then
    # 进入仓库目录
    cd $repo_name
    echo "已进入目录：$(pwd)"

    # 拉取最新代码
    echo "正在拉取最新代码..."
    git pull

    # 返回上级目录
    cd ..
    echo "已返回上级目录：$(pwd)"
else
    # 克隆GitHub仓库
    echo "正在克隆GitHub仓库..."
    git clone -b master $repo_url
fi

# 提示用户输入版本号
read -p "请输入版本号: " version

# 进入仓库目录
cd $repo_name
echo "已进入目录：$(pwd)"

# 检查镜像是否已存在
if [ "$(docker images -q $repo_name:$version 2> /dev/null)" == "" ]; then
    # 构建Docker镜像
    echo "正在构建Docker镜像..."
    docker build -t $repo_name:$version .
fi

# 返回上级目录
cd ..
echo "已返回上级目录：$(pwd)"

# 修改版本号
echo $version > $repo_name/version.txt

# 输出执行完成信息
echo "[$(date)]:脚本执行完成！"
