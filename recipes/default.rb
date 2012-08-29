include_recipe "git"
include_recipe "zsh"

node[:oh_my_zsh][:users].each do |user|

  user_name = user['user_name']
  user_dir  = user['home_dir'] || "/home/#{user_name}"
  zsh_theme = user['theme'] || 'robbyrussell'

  git "#{user_dir}/.oh-my-zsh" do
    repository "https://github.com/robbyrussell/oh-my-zsh.git"
    reference "master"
    user user_name
    group user_name
    action :checkout
    not_if "test -d #{user_dir}/.oh-my-zsh"
  end

  template "#{user_dir}/.zshrc" do
    source "zshrc.erb"
    owner user_name
    group user_name
    variables( :zsh_theme => ( zsh_theme ))
    action :create_if_missing
  end
end
