#!/bin/bash

echo "版本：0.9"
echo "本脚本只适用于快速改root密码抢别人送的vps，不适宜用于自用机子，更不适用于生产环境，如果你在自用机子和生产环境上使用本脚本导致无法连接上ssh，后果自负！！！"

# 检查是否为 root 用户
if [ "$(id -u)" != "0" ]; then
   echo "脚本必须以root用户运行" 1>&2
   exit 1
fi

# 检查SSH设置并提供警告
check_root_login() {
    echo "当前SSH root登录设置:"
    grep -E "^PermitRootLogin|^PasswordAuthentication" /etc/ssh/sshd_config

    permitRootLogin=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | cut -d ' ' -f2)
    passwordAuthentication=$(grep "^PasswordAuthentication" /etc/ssh/sshd_config | cut -d ' ' -f2)

    echo "解释："
    case "$permitRootLogin" in
        "yes") echo "- PermitRootLogin yes: 允许root用户通过SSH登录" ;;
        "prohibit-password") echo "- PermitRootLogin prohibit-password: 禁止root用户使用密码登录SSH，但允许使用其他方式（如密钥）" ;;
        "no") echo "- PermitRootLogin no: 完全禁止root用户通过SSH登录" ;;
    esac

    case "$passwordAuthentication" in
        "yes") echo "- PasswordAuthentication yes: 允许使用密码进行SSH认证" ;;
        "no") echo "- PasswordAuthentication no: 禁止使用密码进行SSH认证，只能使用密钥等其他方式" ;;
    esac

    echo "总结："
    if [[ "$permitRootLogin" == "yes" && "$passwordAuthentication" == "yes" ]]; then
        echo "当前设置允许使用密码进行root SSH登录。"
    else
        echo "警告：当前设置不允许使用密码进行root SSH登录。"
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

# 提示用户选择
echo "按 Enter 键生成随机密码，或按任意其他键自定义密码。"
read -n 1 -s -r key

# 替换原来的 read 命令
if [ -t 0 ]; then
    # 终端是交互式的
    read -n 1 -s -r -t 60 key
else
    # 非交互式环境，等待一段时间给用户机会输入
    read -n 1 -s -r -t 10 key
fi

if [ -z "$key" ]; then
    # 生成随机密码
    new_password=$(generate_password)
    echo "生成了新的root密码:$new_password"
else
    # 使用自定义密码
    echo -e "\n请输入新的root密码：（输入不显示内容是正常的）"
    read -s new_password
    echo "请再次输入新的root密码：（输入不显示内容是正常的）"
    read -s new_password_confirm
    
    if [ "$new_password" != "$new_password_confirm" ]; then
        echo "两次输入的密码不匹配，请重新运行脚本。"
        exit 1
    fi
fi


# 更改 root 密码
echo "root:$new_password" | chpasswd

# 检查密码是否成功更改
if [ $? -eq 0 ]; then
    echo "root密码已经被成功更改为:$new_password"
else
    echo "更改root密码失败，请重试"
    exit 1
fi

echo "再次提醒：如果系统配置为禁止root密码登录，这个更改可能不会影响SSH登录。"
echo "您可以自行检查 /etc/ssh/sshd_config 文件以确认当前的SSH登录设置。"


echo "请确保你已经保存了这个新的root密码:$new_password"
echo "建议不要直接断开ssh重连，而是新开一个ssh窗口连接尝试"
