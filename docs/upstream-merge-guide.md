# Upstream 分支合并指南

本文档用于将上游仓库（`upstream`）的分支合并到你自己的仓库分支（通常是 `main`）中，并覆盖冲突处理、验证与回滚。

## 1. 目标与原则

- 目标：把 `upstream/<branch>` 的最新改动合并到当前项目分支。
- 原则：先同步、再合并、后验证；不要在有未提交改动时直接开合并。

## 2. 准备工作

### 2.1 检查远程配置

```bash
git remote -v
```

预期：
- `origin` 指向你自己的仓库。
- `upstream` 指向上游仓库。

若没有 `upstream`，添加：

```bash
git remote add upstream <upstream-repo-url>
```

### 2.2 检查当前工作区状态

```bash
git status
```

如果有未提交改动，建议先处理：

```bash
git add -A
git commit -m "WIP: before merging upstream"
```

或临时存起来：

```bash
git stash push -u -m "temp-before-upstream-merge"
```

## 3. 标准合并流程（推荐）

### 3.1 拉取远程分支信息

```bash
git fetch origin
git fetch upstream
```

### 3.2 切换到目标分支并先和 `origin` 同步

```bash
git checkout main
git pull origin main
```

如果你的主分支是 `master`，把上面命令中的 `main` 改为 `master`。

### 3.3 创建合并工作分支（强烈推荐）

```bash
git checkout -b chore/merge-upstream-main-$(date +%Y%m%d)
```

这样即使有冲突，你也不会直接污染主分支。

### 3.4 执行合并

```bash
git merge upstream/main
```

如果要合并其他分支，如 `release/v2`：

```bash
git merge upstream/release/v2
```

## 4. 冲突处理

### 4.1 定位冲突文件

```bash
git status
git diff --name-only --diff-filter=U
```

### 4.2 手动处理冲突标记

冲突文件会出现如下标记：

```text
<<<<<<< HEAD
你的改动
=======
upstream 的改动
>>>>>>> upstream/main
```

处理方式：
- 删除冲突标记。
- 保留正确内容（可能是二者合并）。
- 保存文件。

### 4.3 标记已解决并完成 merge commit

```bash
git add <resolved-file-1> <resolved-file-2>
git commit
```

> 注意：`git commit` 此时会创建一次合并提交。

## 5. Nix 仓库常见冲突建议

本仓库是 Nix flake 项目，建议优先关注：

- `flake.lock`：最常见冲突文件。  
  一般做法是优先保留你期望的输入版本，然后执行一次校验命令确认锁文件有效。
- `flake.nix`：检查输入源（`inputs`）和输出（`outputs`）逻辑是否被意外覆盖。
- 模块聚合文件（如 `default.nix`）：确认模块导入顺序和启用项没有被误删。

建议在冲突解决后至少执行：

```bash
nix flake check
```

若你平时通过脚本构建，也可执行对应脚本再验证一轮。

## 6. 合并后的验证与推送

```bash
# 根据你的项目实际命令做检查
nix flake check

# 推送合并分支
git push -u origin chore/merge-upstream-main-$(date +%Y%m%d)
```

然后提 PR 合并回 `main`，由 CI 再做一次兜底验证。

如果你是在 `main` 上直接合并并确认无误：

```bash
git push origin main
```

## 7. 回滚与中止

### 7.1 合并过程中想放弃

```bash
git merge --abort
```

### 7.2 合并已提交但还没推送

```bash
git log --oneline -n 5
git reset --hard <merge-commit-before>
```

> `reset --hard` 是破坏性操作，确认没有需要保留的本地改动再执行。

### 7.3 已推送到远程

优先使用反向提交，而不是强推改历史：

```bash
git revert -m 1 <merge_commit_sha>
git push origin <branch>
```

## 8. 可直接复用的命令模板

```bash
# 1) 准备
git remote -v
git status
git fetch origin
git fetch upstream

# 2) 同步主分支并创建合并分支
git checkout main
git pull origin main
git checkout -b chore/merge-upstream-main-$(date +%Y%m%d)

# 3) 合并 upstream/main
git merge upstream/main

# 4) 若有冲突：编辑文件 -> git add -> git commit
git status
git diff --name-only --diff-filter=U

# 5) 校验并推送
nix flake check
git push -u origin chore/merge-upstream-main-$(date +%Y%m%d)
```

## 9. 最佳实践清单

- 合并在独立分支做，不直接在 `main` 上做。
- 每次合并前确保工作区干净（`git status`）。
- 冲突按“配置/锁文件 -> 核心逻辑 -> 边缘文件”顺序处理。
- 合并后一定跑验证命令，不要只看 `git` 状态。
- 保留合并提交历史，便于后续排查来源与回滚。
