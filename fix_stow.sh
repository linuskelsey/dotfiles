cd ~/.dotfiles
for pkg in */; do
  inner="$pkg.config/${pkg%/}/${pkg%/}"
  if [ -d "$inner" ]; then
    echo "Fixing $pkg..."
    mv "$inner"/* "$pkg.config/${pkg%/}/"
    rmdir "$inner"
  fi
done
