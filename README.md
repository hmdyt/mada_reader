# MadaReader
Gigabit Iwakiboard decoder

## Dependencies
- ROOT
- Elixir

## Installation

```bash
git clone https://github.com/hmdyt/mada_reader.git
cd mada_reader
source setup.sh
```

## Usage
### 1ボード分のmadaファイルをダンプする

```bash
./mada_reader GBKB-XX_YYYY.mada rootfilename.root
```

### ダンプされた1ボードのあるイベントをみる (未実装)

```bash
one_event_viewer rootfilename.root treename i_event
```