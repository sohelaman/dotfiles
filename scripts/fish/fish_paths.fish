
# FISH SHELL SCRIPT

if [ -d $DOCUMENT_ROOT ]
    set www_dir $DOCUMENT_ROOT
end


## Add binaries to path
if type -q composer
    if [ ! $COMPOSER_BIN_PATH ]
        set -gx PATH $PATH ~/.config/composer/vendor/bin
    else
        set -gx PATH $PATH $COMPOSER_BIN_PATH
    end
end

if type -q java; and [ -z $JAVA_HOME ]
    export JAVA_HOME=/usr/lib/jvm/default-java
end
