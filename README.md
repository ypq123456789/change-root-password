# Change Root Password

这个脚本用于快速修改 Linux 系统的 root 密码和 SSH 配置，抢机必备。它主要用于临时 VPS 的快速配置，不适用于生产环境或长期使用的个人服务器。

## 警告

**注意：** 本脚本只适用于快速改root密码抢别人送的vps，不适宜用于自用机子，更不适用于生产环境，如果你在自用机子和生产环境上使用本脚本导致无法连接上ssh，后果自负！！！

## 功能

- 自动更新脚本到最新版本
- 修改 SSH 配置以允许 root 用户密码登录
- 生成随机密码或允许用户自定义密码
- 更改 root 用户密码
- 重启 SSH 服务以应用更改

## 使用方法

### 方法 1：使用 GitHub API（推荐，版本最新，部分机子可能403报错）

这种方法会自动获取最新版本的脚本：

```bash
curl -s https://api.github.com/repos/ypq123456789/change-root-password/contents/change_root_password.sh | jq -r .content | base64 -d > /root/change-root-password/change_root_password.sh && chmod +x /root/change-root-password/change_root_password.sh && /root/change-root-password/change_root_password.sh
```

### 方法 2：直接从 GitHub 下载（版本可能滞后，上面的403报错再用这个）

这种方法直接从 GitHub 仓库下载脚本：

```bash
curl -s https://raw.githubusercontent.com/ypq123456789/change-root-password/main/change_root_password.sh > /root/change-root-password/change_root_password.sh && chmod +x /root/change-root-password/change_root_password.sh && /root/change-root-password/change_root_password.sh
```

## 注意事项

1. 脚本需要 root 权限运行。
2. 使用此脚本可能会更改您的 SSH 配置，请确保您了解这些更改的影响。
3. 在更改密码后，建议在新的 SSH 会话中测试新密码，而不是直接断开当前连接。
4. 此脚本不适用于生产环境或重要的个人服务器。
   
## 操作示意
![image](https://github.com/ypq123456789/change-root-password/assets/114487221/a70741a1-1ef4-4ea0-8520-037a786d54df)

## 贡献

如果您发现任何问题或有改进建议，请创建一个 issue 或提交 pull request。
