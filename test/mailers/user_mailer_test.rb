require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
  
  test "password_reset" do
    # ユーザーを設定する
    user = users(:michael)
    # リセット用トークンを設定する(本来ならば、create_reset_digest内で行われているがメールを送らないのでdigest保存もしない関係でtokenの設定のみ)
    user.reset_token = User.new_token
    # リセットメール送信
    mail = UserMailer.password_reset(user)
    # メール件名がPassword reset
    assert_equal "Password reset", mail.subject
    # ユーザーのメールアドレスに送られているか
    assert_equal [user.email], mail.to
    # "noreply@example.com"から送信されているか
    assert_equal ["noreply@example.com"], mail.from
    # メール本文にリセット用トークンが入っているか
    assert_match user.reset_token,        mail.body.encoded
    # CGIエスケープされたユーザーのメールアドレスが入っているか
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
