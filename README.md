# MadaReader
Gigabit Iwakiboard decoder
- ボードからの出力をパッと可視化するためのツール

## Dependencies
- ROOT
- Elixir

## Installation
- 依存しているC++のソースをコンパイルしパスを通す
- Elixirのパッケージ管理ツールmixで実行ファイルを作成する

```bash
git clone https://github.com/hmdyt/mada_reader.git
cd mada_reader
source setup.sh
```

## Usage

```bash
mada_reader --help
```

### 1ボード分のmadaファイルをダンプする

```bash
mada_reader file GBKB-XX_YYYY.mada rootfilename.root
```

### ダンプされた1ボードのあるイベントをみる

```bash
one_event_viewer rootfilename.root treename i_event output_image.png
```

### 指定ディレクトリ内のmadaファイルを全てダンプする

```bash
mada_reader dir /path/to/perXXXX nprocs
```

## コンテナ上で動かす
- ROOT, Elixir等の依存パッケージ不要
- mada_reader下に任意の.madaファイルをコピーしてきて使う

```bash
cp -r /path/to/per0000 data/.
```

```bash
docker-compose build
docker-compose up -d
docker-compose exec mada_reader bin/mada_reader file data/per0000/GBKB-XX_YYYY.mada out.root
```