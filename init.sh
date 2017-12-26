checkAndCreateDir(){
  if [ ! -d $1 ] ; then
      sudo mkdir -p $1
      return 1
  else
      return 0
  fi
}

checkAndCreateFile(){
  if [ ! -f $1 ] ; then
      touch $1
      return 1
  else
      return 0
  fi
}

checkCommand(){
    if [ -n `which $1` ]; then
      return 0
    else
      return 1
    fi
}
checkCommandAndInstall(){
    if which -s $1 ; then
      echo "$1 已安装"
    else
      echo "try to insall $1 "
      brew install $1
    fi
}
yes_or_no(){
    while true
    do
        echo "$1 , 请输入 yes 或 no : "  
        read x
        case $x in
            y|yes|Y|YES ) return 0;; 
            n|no|N|NO  ) return 1;;
            * ) echo "Answer yes or no!" 
       esac
     done
}
ifInstallByBrew(){
    
    if which -s $1 ; then
        echo "$1 已安装"
    else
        if yes_or_no "是否需要安装 $1 " ; then
            echo "尝试安装 $1 "
            brew install $1
        else
            echo "$1 安装取消"
        fi    
    fi
}
installFromDmg(){
   exit
}
echo "start instation..."
echo "init soft dir"
SOFTDIR=/opt/soft
WORKDIR=~/work
PWD=`pwd`
if checkAndCreateDir $SOFTDIR ; then
    chmod -R 777 $SOFTDIR
else
    echo "$SOFTDIR exist"
fi
if checkAndCreateDir $WORKDIR ; then
    chmod -R 777 $SOFTDIR
else
    echo "$WORKDIR exist"
fi

if checkAndCreateFile ~/.vimrc ; then
    echo "syntax on\nset nu ts=4 sw=4" >> ~/.vimrc
fi
if  checkCommand brew ; then
    echo "brew 已安装"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
checkCommandAndInstall nginx
checkCommandAndInstall git
checkCommandAndInstall wget
if  checkCommand adb  ; then
    echo "adb 已安装"
else
    cd $SOFTDIR
    wget http://wireless.taobao.net/download/android_sdk.tar
    tar xvf android_sdk.tar
    rm -f android_sdk.tar
    cd android_sdk
    HR=`pwd`
    echo "PATH=\$PATH:$HR/platform-tools" >> ~/.bash_profile
fi
ifInstallByBrew ffmpeg
ifInstallByBrew OpenCV
ifInstallByBrew macdown

if yes_or_no "是否需要安装 Apache Maven(3.5.2) " ; then
  cd $SOFTDIR
  wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.zip
  unzip apache-maven-3.5.2-bin.zip
  rm -f apache-maven-3.5.2-bin.zip
  echo "PATH=\$PATH:$SOFTDIR/apache-maven-3.5.2/bin" >> ~/.bash_profile
  mkdir -p ~/.m2
  echo """<?xml version="1.0"?>

<settings>
    <servers>
        <server>
            <id>snapshots</id>
            <username>snapshotsAdmin</username>
            <password>123456</password>
        </server>
        <server>
            <id>releases</id>
            <username>admin</username>
            <password>screct</password>
        </server>
    </servers>

    <!-- ======================================================================== -->
    <!--  mirror settings                                                         -->
    <!-- ======================================================================== -->
    <mirrors>
        <mirror>
            <id>tbmirror-all</id>
            <mirrorOf>*</mirrorOf>
            <name>taobao mirror</name>
            <url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
        </mirror>
    </mirrors>

        <profiles>
                <profile>
                        <id>nexus</id>
                        <repositories>
                                <repository>
                                        <id>central</id>
                                        <url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
                                </repository>
                        </repositories>
                        <pluginRepositories>
                                <pluginRepository>
                                        <id>central</id>
                                        <url>http://mvnrepo.alibaba-inc.com/mvn/repository</url>
                                </pluginRepository>
                        </pluginRepositories>
                </profile>
        </profiles>

        <pluginGroups>
                         <pluginGroup>com.alibaba.org.apache.maven.plugins</pluginGroup>
                         <pluginGroup>com.alibaba.maven.plugins</pluginGroup>
        </pluginGroups>

    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>
</settings>""" >>  ~/.m2/settings.xml
fi
