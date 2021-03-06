# README

## アプリケーション概要
ShareMusicはSpotifyで作成したプレイリストを共有することができるアプリケーションです。
利用ユーザーはプレイリストの投稿、投稿されたプレイリストを利用することができます。
また、検索やハッシュタグを利用することで、自分の聞きたいプレイリストを探すことができます。

## 目指した課題解決
音楽を聴くことが好きな人たちが、新しい音楽と出会うことができるように、シーンに合った音楽を簡単に見つけることができるようにアプリの作成を行いました。

## URL
https://share-music.herokuapp.com/

## テスト用アカウント
Email: test@com
password: test123

## 利用方法
アカウントにログインし、投稿画面に遷移します。
プレイリストのタイトル、spotifyのプレイリストのurl、画像を添付することで投稿することが可能です。
また、検索フォームから好きな曲、気分、単語などで検索し、投稿一覧から興味のあるプレイリストをクリックし、「spotifyで聴く」をクリックすることでspotifyに遷移することが可能です。

## 洗い出した用件
- ユーザー管理機能
- プレイリスト投稿機能
- タグ機能
- 検索機能
- いいね機能
- ランキング機能
- SNS共有機能

## 操作概要
- プレイリスト投稿機能
https://gyazo.com/6d8f15f7cacfed458b2249ac17801cac
- タグ機能
https://gyazo.com/80427c79c045b26af4bf42d26db48d13
- 検索機能
https://gyazo.com/7b56375e08eaf44b51a59bb94d2612fe
- いいね機能
https://gyazo.com/32ba3e0a9748de70ad7fb6aa1f47e0cb
- ランキング機能
https://gyazo.com/62f32f42fc233f50245facbe1bf8fba1
- SNS共有機能
https://gyazo.com/cd976adab855757fc511429134a02857

## 実装予定の機能
- ~~他の音楽配信サービスによる投稿~~
 →urlからプレイリストの曲を取得できるAPIがなかった
- レスポンシブデザイン対応


## データベース設計
- ER図
https://gyazo.com/216c4a1aca0c51426a8c4c850a65fb95

### usersテーブル
| Column             | Type          | Options                   | 
| ------------------ | ------------- | ------------------------- | 
| name               | string        | null: false, unique: true | 
| encrypted_password | string        | null: false               | 
| email              | string        | null: false               | 
| image              | ActiveStorage |                           | 

#### Association
- has_many :posts
- has_many :likes
- has_one_attached :image

### postsテーブル
| Column | Type          | Options                        | 
| ------ | ------------- | ------------------------------ | 
| title  | string        | null: false                    | 
| url    | string        | null: false                    | 
| image  | ActiveStorage |                                | 
| user   | references    | null: false, foreign_key: true | 

#### Association
- has_many :likes
- belongs_to :user
- has_one_attached :image
- ~~has_many :tags, through :post_tags~~ → acts_as_taggable 
- has_many :playlists
- has_many :musics, through: :playlists

### likesテーブル
| Column | Type       | Options                        | 
| ------ | ---------- | ------------------------------ | 
| user   | references | null: false, foreign_key: true | 
| post   | references | null: false, foreign_key: true | 

#### Association
- belongs_to :user
- belongs_to :post

### musicsテーブル
| Column | Type       | Options                        | 
| ------ | ---------- | ------------------------------ | 
| track  | string     | null: false, uniqueness: true  | 

#### Association
- has_many :playlists
- has_many :posts, through: :playlists

### playlistsテーブル
| Column | Type       | Options                        | 
| ------ | ---------- | ------------------------------ | 
| post   | references | null: false, foreign_key: true | 
| music  | references | null: false, foreign_key: true | 

#### Association
- belongs_to :post
- belongs_to :music