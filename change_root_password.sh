#!/bin/bash

echo "版本：0.1"

# 检查是否为 root 用户
if [ "$(id -u)" != "0" ]; then
   echo "脚本必须以root用户运行" 1>&2
   exit 1
fi

# 生成随机密码的函数
generate_password() {
    tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 16
}

# 如果提供了参数，使用它作为新密码；否则生成随机密码
if [ $# -eq 1 ]; then
    new_password="\$1"
else
    new_password=$(generate_password)
    echo "生成了新的root密码: $new_password"
fi

# 更改 root 密码
echo "root:$new_password" | chpasswd

# 检查密码是否成功更改
if [ $? -eq 0 ]; then
    echo "root密码已经被成功更改"
else
    echo "更改root密码失败，请重试"
    exit 1
fi

# 如果使用随机生成的密码，再次显示密码
if [ $# -eq 0 ]; then
    echo "请确保你已经保存了这个新的root密码: $new_password"
fi
