#!/bin/bash

echo "版本：0.2"

# 检查是否为 root 用户
if [ "$(id -u)" != "0" ]; then
   echo "脚本必须以root用户运行" 1>&2
   exit 1
fi

# 检查是否允许root密码登录
check_root_login() {
    if grep -q "^PermitRootLogin prohibit-password" /etc/ssh/sshd_config; then
        echo "警告：当前系统配置不允许root使用密码登录SSH。"
        echo "修改root密码可能对SSH登录没有实际影响。"
        echo "如果你确定要继续，请输入'yes'，否则脚本将退出。"
        read -r response
        if [[ ! $response =~ ^[Yy][Ee][Ss]$ ]]; then
            echo "脚本已退出。"
            exit 0
        fi
    fi
}

# 执行检查
check_root_login

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

echo "注意：如果系统配置为禁止root密码登录，这个更改可能不会影响SSH登录。"
echo "请检查 /etc/ssh/sshd_config 文件以确认当前的SSH登录设置。"
