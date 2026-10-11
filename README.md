# LockVocab(ロック画面 多言語単語アプリ)

> ⚠️ このコードはLinux環境で作成したため、**ビルドも実機動作も未検証**です。
> 初回ビルドでエラーが出る可能性があります。エラー文を貼ってもらえれば修正します。

## 必要なもの
- macOS + Xcode 15以上(クラウドMacでも可)
- iPhone(iOS 17以上)
- Apple ID(無料でも実機実行は可能だが7日で失効。App Groupsが無料枠で通るかは未確認)

## 構成
```
project.yml            XcodeGen設定(プロジェクト自動生成)
Shared/                アプリとウィジェット両方に入るコード
App/                   アプリ本体のみ(ターゲット: LockVocab)
Widget/                ウィジェットのみ(ターゲット: LockVocabWidget)
.github/workflows/     CIでのコンパイル確認(任意)
```

## 手順
1. 識別子を自分用に変更(**3か所を同じ意味で揃える**)
   - `project.yml` の `com.example.lockvocab`(2か所:アプリ/ウィジェット+.widget)
   - `project.yml` の `group.com.example.lockvocab`(2か所)
   - `Shared/AppGroup.swift` の `group.com.example.lockvocab`
2. `brew install xcodegen` → フォルダで `xcodegen generate` → `LockVocab.xcodeproj` を開く
3. 両ターゲット(LockVocab / LockVocabWidget)の Signing & Capabilities で Team を選択。App Groups に同じグループが入っていることを確認
4. iPhoneをつなぎ、スキームLockVocabで実機を選んで Run(初回は設定 > 一般 > VPNとデバイス管理 でデベロッパを信頼、開発者モードON)
5. アプリを一度起動 → ロック画面を長押し → カスタマイズ → ロック画面 → ウィジェット追加 → LockVocab「今日の単語」

## 仕様メモ
- 1日1語。奇数日は「苦手」語を優先、偶数日は登録順。「覚えた」は除外
- ウィジェットは今日+7日分を先に生成。日付切替はiOS任せで、秒単位の即時更新は保証されません
- 言語追加は `Shared/Models.swift` の `Language.all` に1行足す + 編集画面は自動で対応
- 未実装: 発音再生、学習記録、例文のウィジェット表示(データ構造は対応済み)

## ビルドエラーが起きやすい所
- App Group / Bundle IDの不一致(Signingで赤エラー)
- Team未設定
- XcodeGenのバージョン差によるproject.ymlの解釈違い
