## 設計案：AmbientNoise

### 1. アーキテクチャ

SwiftUIとの親和性が高い **MVVM (Model-View-ViewModel)** アーキテクチャを採用します。

- **Model:** アプリケーションのデータ構造を定義します。（例: `Sound` オブジェクト）
- **View:** SwiftUIで構築されるUIコンポーネントです。（例: `SoundListView`, `PlayerView`）
- **ViewModel:** Viewの状態を管理し、ビジネスロジック（音声再生、課金処理など）を実行します。

### 2. ファイル構成

プロジェクトの整理と拡張性を考慮し、以下のディレクトリ構成を導入します。

```
AmbientNoise/
├── Models/
│   └── Sound.swift         # サウンドデータのモデル
├── ViewModels/
│   └── SoundViewModel.swift  # サウンドリストと再生状態を管理
├── Views/
│   ├── SoundListView.swift   # サウンド選択画面
│   └── PlayerView.swift      # 再生画面
└── Services/
    ├── AudioPlayerService.swift # AVFoundationを使った音声再生ロジック
    └── StoreService.swift       # StoreKitを使った課金処理ロジック
```

### 3. 主要コンポーネント設計

#### 3.1. Model: `Sound.swift`

サウンドの属性を定義する`struct`を作成します。

- `id`: `UUID`
- `name`: `String` (例: "White Noise")
- `fileName`: `String` (音声ファイル名)
- `imageName`: `String` (背景画像名)
- `isPremium`: `Bool` (課金アイテムかどうかのフラグ)

#### 3.2. ViewModel: `SoundViewModel.swift`

`ObservableObject`として、UIに公開するデータを管理します。

- `@Published var sounds`: `[Sound]` - 表示するサウンドのリスト
- `@Published var selectedSound`: `Sound?` - 現在選択中のサウンド
- `@Published var isPlaying`: `Bool` - 再生状態
- `play()`, `pause()` メソッド

#### 3.3. Service: `AudioPlayerService.swift`

`AVFoundation` (`AVAudioEngine`, `AVAudioPlayerNode`) をラップし、音声再生を専門に担当するクラス。ホワイトノイズやブラウンノイズはプログラムで生成します。

#### 3.4. View: `SoundListView.swift` & `PlayerView.swift`

- `SoundListView`: `SoundViewModel` からサウンドリストを受け取り、`LazyVGrid` を使ってカード形式で表示します。
- `PlayerView`: サウンドが選択された時に表示される画面。背景画像の上に再生/停止ボタンや音量スライダーを `ZStack` を使って配置します。

### 4. 段階的な実装計画

1.  **基本構造の構築:** 上記ファイル構成に基づき、空のファイルとディレクトリを作成します。
2.  **モデル定義:** `Sound.swift` を実装します。
3.  **音声再生機能 (無料版):** `AudioPlayerService` を実装し、まずホワイトノイズとブラウンノイズを再生できるようにします。
4.  **UI実装 (リスト表示):** `SoundViewModel` と `SoundListView` を実装し、無料ノイズをリスト表示します。
5.  **UI実装 (再生画面):** `PlayerView` の基本的なレイアウト（背景画像と再生ボタン）を実装します。

### 5. 想定される課題

- **ノイズ生成:** 各色のノイズを正確にプログラムで生成するには、デジタル信号処理の知識が必要です。まずは基本的な実装から開始します。
- **課金処理:** `StoreKit` の実装は複雑なため、初期段階では購入済みかを判定するダミーのロジックを実装します。
- **バックグラウンド再生:** Info.plistの設定と、バックグラウンドでのオーディオセッション管理が必要です。
