#/bin/bash

find assets -type f -name '*.aseprite' -exec sh -c '
  for file do
    /home/ionshard/AppImages/aseprite.appimage \
      --batch "$file" \
      --sheet "${file%.aseprite}.png"
  done
' sh {} +
