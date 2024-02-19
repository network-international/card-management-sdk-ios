#!/bin/sh

readonly arguments=$@

# do not forget to make it executable
# chmod 755 generateNetwork.sh
# chmod +x generateNetwork.sh

readonly default_style='\033[0m'
readonly warning_style='\033[33m'
readonly error_style='\033[31m'
readonly required_macos_version='10.15.0'
readonly homebrew_url='https://raw.githubusercontent.com/Homebrew/install/master/install'
readonly rbenv_doctor_url='https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor'
readonly rbenv_doctor_temp_path="${project_path}/rbenv_doctor"
readonly rbenv_shell_init_line='eval "$(rbenv init -)"'

readonly update_gems_flag='--update-gems'
readonly update_pods_flag='--update-pods'

readonly project_path="$( pwd )"

readonly required_ruby_version=$(cat .ruby-version)

readonly project_style='\033[38;5;196m'
readonly macos_style='\033[38;5;99m'
readonly xcode_style='\033[38;5;75m'
readonly homebrew_style='\033[38;5;208m'
readonly rbenv_style='\033[38;5;43m'
readonly ruby_style='\033[38;5;89m'
readonly bundler_style='\033[38;5;45m'
readonly cocoapods_style='\033[38;5;161m'
readonly congratulations_style='\033[38;5;48m'

cleanup() {
  rm -rf $rbenv_doctor_temp_path;
}

failure() {
  echo "❌ ${error_style}Error:${default_style} '$1' exit code $2"
  exit 1
}

warning() {
  echo "❕ ${warning_style}Warning:${default_style} '$1' exit code $2"
}

assert_failure() {
  eval $1 2>&1 | sed -e "s/^/    /"

  local exit_code=${PIPESTATUS[0]}

  if [ $exit_code -ne 0 ]; then
    failure "$1" $exit_code
  fi
}

assert_warning() {
  eval $1 2>&1 | sed -e "s/^/    /"

  local exit_code=${PIPESTATUS[0]}

  if [ $exit_code -ne 0 ]; then
    warning "$1" $exit_code
  fi
}

plain_version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d", $1,$2,$3,$4); }'
}

########################################################################################

welcome_message_step() {
  echo "${default_style}"
  echo "--------------------------------------------------------------------------"
  echo "---                                                                    ---"
  echo "---  This will generate network layer based on openapi spec files  ---"
  echo "---                                                                    ---"
  echo "--------------------------------------------------------------------------"
  echo ""
}

macos_version_step() {
  echo ""
  echo "🕧 Check macOS varsion ${macos_style}macOS${default_style}:"

  macos_version=$(/usr/bin/sw_vers -productVersion  2>&1)

  if [ "$(plain_version $macos_version)" -lt "$(plain_version $required_macos_version)" ]; then
    echo "  ${error_style}version macOS($macos_version) should be at least ($required_macos_version). Exit...${default_style}"
    exit 1
  else
    echo "✅ macOS version: $macos_version"
  fi
}

xcode_command_line_tools_step() {
  echo ""
  echo "🕧 Check ${xcode_style}Xcode Command Line Tools${default_style}:"
  if ! xcode-select --version &> /dev/null; then
    assert_failure 'xcode-select --install'
    assert_failure 'xcode-select -v'
  fi
  echo "✅ Xcode Command Line Tools installed"
}

homebrew_step() {
  echo ""
  echo "🕧 Check ${homebrew_style}Homebrew${default_style}:"

  if which -s brew; then
    echo "ℹ️ Homebrew installed. Updating..."
    assert_failure 'brew update'
  else
    assert_failure 'ruby -e "$(curl -fsSL $homebrew_url)" < /dev/null'
  fi

  echo ""
  echo "ℹ️ Check Homebrew was configured..."
  assert_warning 'brew doctor'
  echo "✅ Homebrew configured"
}

rbenv_shell_step() {
  shell_profile_path=$1
  if ! [[ -f $shell_profile_path ]]; then
    echo "ℹ️ File ($shell_profile_path) not found. Creating..."
    assert_failure 'touch $shell_profile_path'
  fi

  shell_profile_content=$(grep rbenv $shell_profile_path 2> /dev/null)

  if [[ $shell_profile_content != *"$rbenv_shell_init_line"* ]]; then
    echo $rbenv_shell_init_line >> $shell_profile_path
  fi
}

rbenv_step() {
  echo ""
  echo "🕧 Check ${rbenv_style}rbenv${default_style}:"

  if brew ls --versions rbenv &> /dev/null; then
    echo "ℹ️ rbenv installed. Updating..."
    brew_outdated=$(brew outdated 2> /dev/null)
    brew_outdated_exit_code=$?

    if [ $brew_outdated_exit_code -ne 0 ]; then
      echo "    Failed to check updats."
      warning 'brew outdated' $brew_outdated_exit_code
    else
      if [[ $brew_outdated == *"rbenv"* ]]; then
        assert_failure 'brew upgrade rbenv'
      fi
    fi
  else
    assert_failure 'brew install rbenv'
  fi

  assert_warning 'rbenv rehash'

  rbenv_shell_step "${HOME}/.bash_profile"
  rbenv_shell_step "${HOME}/.zshrc"
  eval "$(rbenv init -)"

  echo "ℹ️ Check rbenv configured..."
  curl -fsSL $rbenv_doctor_url > $rbenv_doctor_temp_path 2> /dev/null
  rbenv_doctor_exit_code=$?

  if [ $rbenv_doctor_exit_code -ne 0 ]; then
    echo "    Failed to load rbenv-doctor."
    warning 'curl -fsSL $rbenv_doctor_url' $rbenv_doctor_exit_code
  else
    chmod a+x $rbenv_doctor_temp_path
    assert_warning 'bash $rbenv_doctor_temp_path'
  fi
  echo "✅ rbenv installed"
}

ruby_step() {
  echo ""
  echo "🕧 Check ${ruby_style}Ruby${default_style} version ($required_ruby_version):"

  ruby_versions=($(rbenv versions 2>&1))

  if ! [[ " ${ruby_versions[@]} " =~ " ${required_ruby_version} " ]]; then
    assert_failure 'rbenv install $required_ruby_version'
    assert_warning 'rbenv rehash'
  fi
  echo "✅ Ruby installed"
}

bundler_step() {
  echo ""
  echo "🕧 Check ${bundler_style}Bundler${default_style}:"

  if rbenv which bundler &> /dev/null; then
    echo "ℹ️ Bundler installed. Updating..."
    assert_failure 'gem update bundler'
    assert_failure 'bundle update --bundler'
  else
    assert_failure 'gem install bundler'
  fi

  assert_warning 'rbenv rehash'
  echo "✅ Bundler installed"
}

gemfile_step() {
  echo ""
  echo "🕧 Check ${bundler_style}Ruby gems${default_style} from Gemfile:"
  if [[ " ${arguments[*]} " == *" $update_gems_flag "* ]]; then
    assert_failure 'bundle update'
  else
    assert_failure 'bundle install'
  fi
  echo "✅ Ruby gems installed"
}

podfile_step() {
  echo ""
  echo "🕧 Check ${bundler_style}Cocoapods${default_style} from Podfile:"
  if [[ " ${arguments[*]} " == *" $update_pods_flag "* ]]; then
    assert_failure 'bundle exec pod update'
  else
    assert_failure 'bundle exec pod install --repo-update'
  fi
  echo "✅ Cocoapods installed"
}

openapiGenerator_step() {
  echo ""
  echo "ℹ️ Don't forget to install Java 11+..."
  echo ">>brew tap AdoptOpenJDK/openjdk"
  assert_failure 'java -version'
  assert_failure 'brew install openapi-generator'
  # check configuration
  # [CLI] https://openapi-generator.tech/docs/configuration/
  # [Swift] https://github.com/OpenAPITools/openapi-generator/blob/master/docs/generators/swift5.md
  # can disabling `hashableModels` help to get rid of AnyCodable ?
  # library=urlsession
  assert_failure 'openapi-generator-cli generate -i sdk_api_0.0.6.json -g swift5 -o temp/SwiftClient --additional-properties=hideGenerationTimestamp=false,nonPublicApi=true,responseAs=AsyncAwait'
  assert_failure 'openapi-generator-cli generate -i openapi.json -g swift5 -o temp/SwiftClientExtended --additional-properties=hideGenerationTimestamp=false,nonPublicApi=true,responseAs=AsyncAwait'

  echo "✅ openapi generator step completed"
}

moveFiles_step() {
  echo ""
  #echo "ℹ️ replace access level public to internal"
  #assert_failure "find . -type f -name '*.swift' -exec sed -i '' s/public/internal/g {} +"
  #assert_failure "find . -type f -name '*.swift' -exec sed -i '' s/open/internal/g {} +"
  #echo "✅ public removed from generated files"
  echo "ℹ️ copy files from temp directory"
  assert_failure "cp -r temp/SwiftClient/OpenAPIClient/Classes/OpenAPIs/ ../CardManagementSDK/Source/OpenAPIs/"
  assert_failure "cp -r temp/SwiftClientExtended/OpenAPIClient/Classes/OpenAPIs/ ../CardManagementSDK/Source/OpenAPIs/"
  echo "✅ files moved to project's directory"
}

congratulations_step() {
  echo ""
  echo ""
  echo "Generation completed"
  echo ""
}

########################################################################################

#trap cleanup EXIT

welcome_message_step
macos_version_step
xcode_command_line_tools_step
homebrew_step
#rbenv_step
#ruby_step
#bundler_step
#gemfile_step
#podfile_step
openapiGenerator_step
moveFiles_step
congratulations_step
