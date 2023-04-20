ruby "3.1.2"

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# gem "breathe", "0.3.5"
gem "breathe", git: "https://github.com/dxw/breathe_ruby", branch: "dragon"
gem "dotenv"
gem "puma"
gem "rake"
gem "sinatra"
gem "sinatra-contrib"

group :development do
  gem "standard"
  gem "byebug"
end

group :test do
  gem "rspec"
end
