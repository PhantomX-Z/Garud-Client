sudo apt-get update && sudo apt install openjdk-17-jdk


export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_ROOT=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH


printf 'Set Java environment variables: Successful\n\n'

SDK_DIR="/opt/android-sdk"

# Check if the directory exists
if [ -d "$SDK_DIR" ]; then
    echo "SDK already exists. Skipping download."
else
    echo "SDK does not exist. Proceeding with download..."

    # Change to /opt directory
    cd /opt || { echo "Failed to change to /opt directory"; exit 1; }

    # Download the latest Android SDK Command Line Tools
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

    # Create the SDK directory and unzip the tools

    mkdir -p $SDK_DIR/cmdline-tools
    unzip commandlinetools-linux-9477386_latest.zip -d $SDK_DIR/cmdline-tools
    
    # Rename the unzipped directory to 'latest'
    mv $SDK_DIR/cmdline-tools/cmdline-tools $SDK_DIR/cmdline-tools/latest
    
    # Remove the zip file
    sudo rm commandlinetools-linux-9477386_latest.zip

    cd android-sdk/cmdline-tools/latest/bin
    ./sdkmanager --licenses
fi

# Set up environment variables for Android SDK
export ANDROID_HOME=/opt/android-sdk >> ~/.bashrc
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH >> ~/.bashrc
export PATH=$ANDROID_HOME/platform-tools:$PATH >> ~/.bashrc




NDK_DIR="/opt/android-ndk-r26b"

# Check if the directory exists
if [ -d "$NDK_DIR" ]; then
    echo "NDK already exists. Skipping download."
else
    echo "NDK does not exist. Proceeding with download..."
    
    # Change to /opt directory
    cd /opt || { echo "Failed to change to /opt directory"; exit 1; }
    
    # Download the NDK zip file
    wget https://dl.google.com/android/repository/android-ndk-r26b-linux.zip
    
    # Unzip the downloaded file
    unzip android-ndk-r26b-linux.zip
    
    # Remove the zip file
    sudo rm android-ndk-r26b-linux.zip
fi

# Reload shell configuration
source ~/.bashrc

cd $HOME/Garud-Client/Android # Change the path before running the script.
./gradlew assembleDebug

