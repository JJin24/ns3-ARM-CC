# ns3-arm-cc

用於交叉編譯 ARM Linux 程式與 ns-3 相關元件的 Docker 開發環境。

基底為 Ubuntu 18.04，內含 ARM GNU toolchain CMake, Ninja, Git, ccache，以及為 ARM 編譯的 libnl 3.2.24。

## 需求

- Docker Desktop 或 Docker Engine
- 若要推送 image：GitHub Container Registry（GHCR）權限

## 建置 image

在本專案目錄執行：

```bash
docker build -f dockerfile -t ns3-arm-cc:latest .
```

確認 image 已建立：

```bash
docker image ls ns3-arm-cc
```

## 啟動容器

背景啟動一個名為 `ns3-arm-cc` 的容器：

```bash
docker run -d --name ns3-arm-cc ns3-arm-cc:latest
```

進入容器：

```bash
docker exec -it ns3-arm-cc bash
```

容器停止後重新啟動：

```bash
docker start ns3-arm-cc
```

不再需要時刪除容器：

```bash
docker rm -f ns3-1
```

## 使用 tmux

由於在進行交叉編譯的過程中，可能會因為 Host 發生 OOM (Out of Memory) 的問題，導致整個桌面系統被 host memory manager 關閉，因此建議可以在進入 Container 之後，使用 tmux 保留工作狀態，方便在崩潰之後可以回復工作狀態。

> [!TIP]
> 如果不想要 Host 發生 OOM 的話，可以對 Container 設定 Memory 的使用上限。

Container 內已安裝 tmux。建立一個工作 session：

```bash
tmux new -s ns3
```

離開 session 但保持它運行：按 `Ctrl+b`，再按 `d`。

重新附加 session：

```bash
tmux attach -t ns3
```

## 上傳至 GitHub Container Registry

先使用擁有 `write:packages` 權限的 GitHub token 登入：

```bash
docker login ghcr.io -u jjin24
```

建立 GHCR tag 並推送：

```bash
docker tag ns3-arm-cc:latest ghcr.io/jjin24/ns3-arm-cc:latest
docker push ghcr.io/jjin24/ns3-arm-cc:latest
```

推送後可從其他電腦拉取：

```bash
docker pull ghcr.io/jjin24/ns3-arm-cc:latest
```
