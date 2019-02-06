

[![ruby version](https://img.shields.io/badge/Ruby-v2.5.3-green.svg)](https://www.ruby-lang.org/ja/)
[![rails version](https://img.shields.io/badge/Rails-v5.2.1-brightgreen.svg)](http://rubyonrails.org/)
[![CircleCI](https://circleci.com/gh/o-t-k-t/moment.svg?style=svg)](https://circleci.com/gh/o-t-k-t/moment)
[![Maintainability](https://api.codeclimate.com/v1/badges/b8fead6e007949d784c0/maintainability)](https://codeclimate.com/github/o-t-k-t/moment/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b8fead6e007949d784c0/test_coverage)](https://codeclimate.com/github/o-t-k-t/moment/test_coverage)


# README

## 要件定義

### 概要

仮想通貨のトレードを自動で行うアプリ。

### コンセプト

働きながら仮想通貨トレードを行う人のための自動トレードアプリです。
理解しやすく実績のある手法を使い、自動で仮想通貨取引を行います。

作者の経験では、個人トレードで利益をあげることことが多いのは、モーメンタム投資などの実績のある伝統的な手法です。また、それらの理論は非常にシンプルであり、それ自体の理解だけでなく、トレードの振り返りも容易な点など、個人投資家に適した点が多いと思います。

しかし、仮想通貨の市場では、値動きが速く激しく、取引の休止がないことから、同様の手法をとるには、トレーダーが常に張り付いて監視を行うする必要がありました。このため仮想通貨の保有自体は最低限のリテラシさえあれば容易にできるのに、職業を持つ個人投資家には明確な戦略をとることが難しく、所謂「ガチホ」と言われるまとめて買ってそのまま見ているという手法がとられました。

これは2018年2月に相場環境の変化が起こってから、損切りの遅れを招き、多くのガチホ投資家に大きな損失を与えました。

このような仮想通貨とその投資に興味はあるものの、生活時間の一部しか投入できない投資家たちに、ボットにより「仮想通貨トレードの生産性を向上」させ、「だれにでも伝統的な手法で仮想通貨トレードを行えるようにする」のがこのアプリケーションです。

### バージョン

Ruby 2.5.3 Rails 5.2.1

### 機能一覧

- ログイン機能
  - ユーザー登録機能
    - Eメール・名前・パスワードは必須
- 仮想通貨取引所Bittrex APIキー保存機能
- パスワード再設定機能
- 稼働中Bot一覧機能
  - Botの状態(監視中・停止中etc)を表示
  - Bot作成機能
  - Bot停止・再開機能
  - Bot雛形機能
- 取引履歴一覧機能

### テーブル定義

https://docs.google.com/spreadsheets/d/1Ak05gPOlvsB912fJ_6BfuKWz2lZPRgJ2-1wl3hPRxig/edit?usp=sharing

### ER図

https://docs.google.com/presentation/d/1LCThs1jzsLxsWBjW2F6Vv7yqmAJbhJtDRcM3aiqQh6w/edit?usp=sharing

### 画面遷移図

https://docs.google.com/spreadsheets/d/1Ak05gPOlvsB912fJ_6BfuKWz2lZPRgJ2-1wl3hPRxig/edit?usp=sharing

### 画面ワイヤーフレーム

https://docs.google.com/presentation/d/1IX3wxLBbS2EAUZUL-kegOxHp70ECoq5hhX2UL0sjK9A/edit?usp=sharing

### 使用予定Gem

- Sidekiq
- AASM
- Devise





















