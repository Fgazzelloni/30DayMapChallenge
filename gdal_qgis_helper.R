# To use sf, terra, and other packages such as rnoaa
# gdal is necessary
# I installed QGIS but it comes with a version of GDAL 
# that is not updated neither useful for installing 
# all functionalities in sf, for example
# so what to do is to instal HOMEBREW on mac with 
# in terminal bash type
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# then 
brew install gdal # it takes long time

# since I had another installation of GDAL from QGIS
# I had to specify which version and location of the GDAL package 
# I want to use
# type in bash
which -a gdalinfo
# two installed version
# /opt/homebrew/bin/gdalinfo
# /Applications/QGIS-LTR.app/Contents/MacOS/bin/gdalinfo

# Update your PATH so Homebrew comes first. In zsh (your default shell):
nano ~/.zshrc # it opens a script page with 

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"
# # Add quarto to the path
# if [[ -d /Users/federicagazzelloni/Applications/quarto/bin ]]; then
# export PATH="/Users/federicagazzelloni/Applications/quarto/bin:$PATH"
# fi

# on top of this file write

export PATH="/opt/homebrew/bin:$PATH"

# the file will be then
# export PATH="/opt/homebrew/bin:$PATH"
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"
# # Add quarto to the path
# if [[ -d /Users/federicagazzelloni/Applications/quarto/bin ]]; then
# export PATH="/Users/federicagazzelloni/Applications/quarto/bin:$PATH"
# fi

# save and exit

# in bash type:
source ~/.zshrc

# and check
which gdalinfo
gdalinfo --version

# here in R set the path- environment
Sys.setenv(PATH = paste("/opt/homebrew/bin", Sys.getenv("PATH"), sep=":"))
install.packages("sf", type = "source")
install.packages("terra", type = "source")
