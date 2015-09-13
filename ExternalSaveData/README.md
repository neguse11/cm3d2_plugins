﻿---
# テスト版です。セーブデータを壊す可能性があるので
# バックアップを取ってから実行してね
---

# セーブデータを拡張するReiPatcher用パッチとManged配置用DLL

このパッチはセーブデータの拡張を他のMODに提供します。単体では何もしません。

  - セーブデータを読み込み/保存する際、同時に拡張セーブデータを読み込み/保存します
  - 標準セーブデータ (.save) の内容はバニラと完全な互換性があります


## 動作の確認

C:\KISS\CM3D2_KAIZOU\CM3D2x64.exe を起動して、セーブデータのロードを行い、
その直後に上書きセーブを行うと、「C:\KISS\CM3D2_KAIZOU\SaveData\」内に XMLファイルが保存されます。
セーブデータ名が「SaveData\SaveData085.save」であれば、「SaveData\SaveData085.save.exsave.xml」というファイルに拡張セーブデータを保存します


## 開発者用：コードの使い方

 - 参照先アセンブリに「C:\KISS\CM3D2_KAIZOU\CM3D2x64_Data\Managed\CM3D2.ExternalSaveData.Managed.dll」を追加
 - コード冒頭に「using CM3D2.ExternalSaveData.Managed;」を追加
 - ExSaveData.Get(...), Set(...) でメイドごとの値を取得、設定
 - ExSaveData.GlobalGet(...), GlobalSet(...) でグローバルな値を取得、設定


## 履歴

 - 0.1.3
   - セーブデータに余分なメイドを保存しないように修正
   - コードの構成を変更
 - 0.1.2
   - 設定削除時のログメッセージを消去 (質問その２>>44)
   - 拡張セーブデータが正常にセーブできていないので元の状態に戻した(その２>>691) (bc47924のコミットを差し戻し)
 - 0.1.1
   - 一部のメソッドにXMLドキュメンテーションコメントを追加 (その２>>497)
   - 説明文(3)項のCM3D2.ExternalSaveData.Patcher.dllの出力先パスの説明が間違っていたのを修正 (その２>>532, 質問その１>>983)
   - ExternalSaveData単体で動作した場合、拡張セーブデータファイル(XML)を出力しないのを修正 (その２>>556, >>561)
   - 設定の削除メソッド ExSaveData.Remove(), GlobalRemove() を追加 (その２>>570)
   - CM3D2.MaidVoicePitch.Pluginが存在しない場合に正常に動作していなかったのを修正 (その２>>573, >>574)
 - 0.1.0
   - 最初の版
