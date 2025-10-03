## タスクリスト：AmbientNoise

### フェーズ 1: 基本構造と音声再生機能

1.  **ディレクトリ作成:**
    - `AmbientNoise` フォルダ内に `Models`, `ViewModels`, `Views`, `Services` の各ディレクトリを作成します。

2.  **モデル (`Sound.swift`) の実装:**
    - `AmbientNoise/Models/Sound.swift` を作成します。
    - `Sound` 構造体を定義します (プロパティ: `id`, `name`, `fileName`, `imageName`, `isPremium`)。

3.  **音声再生サービス (`AudioPlayerService.swift`) の実装:**
    - `AmbientNoise/Services/AudioPlayerService.swift` を作成します。
    - `AVFoundation` をインポートします。
    - `AVAudioEngine` を使用して、ホワイトノイズとブラウンノイズをプログラムで生成し、再生・停止する機能を実装します。

4.  **ビューモデル (`SoundViewModel.swift`) の実装:**
    - `AmbientNoise/ViewModels/SoundViewModel.swift` を作成します。
    - `ObservableObject` に準拠させます。
    - 無料版のサウンド（ホワイトノイズ、ブラウンノイズ）のリストを `@Published` プロパティとして定義します。
    - `AudioPlayerService` と連携し、サウンドの選択と再生状態を管理するロジックを実装します。

### フェーズ 2: UIの実装

5.  **サウンド選択画面 (`SoundListView.swift`) の実装:**
    - `AmbientNoise/Views/SoundListView.swift` を作成します。
    - `SoundViewModel` を受け取り、サウンドのリストをグリッド形式で表示します。
    - 各サウンドをタップすると、再生画面に遷移するようにします。

6.  **再生画面 (`PlayerView.swift`) の実装:**
    - `AmbientNoise/Views/PlayerView.swift` を作成します。
    - `SoundViewModel` を受け取り、選択されたサウンドの背景画像（プレースホルダー）と再生/停止ボタンを表示します。

7.  **メインビュー (`ContentView.swift`) の更新:**
    - `ContentView.swift` の内容を、作成した `SoundListView` に置き換えます。
    - `SoundViewModel` のインスタンスを生成し、View に渡します。

### フェーズ 3: 仕上げ

8.  **アセットの追加:**
    - 無料ノイズ用のシンプルな背景画像を `Assets.xcassets` に追加します。

9.  **バックグラウンド再生の設定:**
    - プロジェクト設定で "Background Modes" を有効にし、"Audio, AirPlay, and Picture in Picture" にチェックを入れます。
