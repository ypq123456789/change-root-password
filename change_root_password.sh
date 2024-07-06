#!/bin/bash

echo "版本：0.10"
echo "本脚本只适用于快速改root密码抢别人送的vps，不适宜用于自用机子，更不适用于生产环境，如果你在自用机子和生产环境上使用本脚本导致无法连接上ssh，后果自负！！！"

# 检查是否为 root 用户
if [ "$(id -u)" != "0" ]; then
   echo "脚本必须以root用户运行" 1>&2
   exit 1
fi

# 检查SSH设置并提供警告
check_root_login() {
    echo "当前SSH root登录设置:"
    grep -E "^#?PermitRootLogin|^#?PasswordAuthentication" /etc/ssh/sshd_config

    permitRootLogin=$(grep "^#*PermitRootLogin" /etc/ssh/sshd_config | tail -n1 | sed 's/^#*//g' | cut -d ' ' -f2)
    passwordAuthentication=$(grep "^#*PasswordAuthentication" /etc/ssh/sshd_config | tail -n1 | sed 's/^#*//g' | cut -d ' ' -f2)

    echo "解释："
    case "$permitRootLogin" in
        "yes") echo "- PermitRootLogin yes: 允许root用户通过SSH登录" ;;
        "prohibit-password") echo "- PermitRootLogin prohibit-password: 禁止root用户使用密码登录SSH，但允许使用其他方式（如密钥）" ;;
        "no") echo "- PermitRootLogin no: 完全禁止root用户通过SSH登录" ;;
        *) echo "- PermitRootLogin: 未找到有效设置，可能使用默认值" ;;
    esac

    case "$passwordAuthentication" in
        "yes") echo "- PasswordAuthentication yes: 允许使用密码进行SSH认证" ;;
        "no") echo "- PasswordAuthentication no: 禁止使用密码进行SSH认证，只能使用密钥等其他方式" ;;
        *) echo "- PasswordAuthentication: 未找到有效设置，可能使用默认值" ;;
    esac

    echo "总结："
    if [[ "$permitRootLogin" == "yes" && "$passwordAuthentication" != "no" ]]; then
        echo "当前设置可能允许使用密码进行root SSH登录。"
    else
        echo "警告：当前设置可能不允许使用密码进行root SSH登录。"
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

# 脚本的其余部分保持不变...
