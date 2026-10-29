export HOME="${HOME}"

vdf="${HOME}/.local/share/Steam/steamapps/libraryfolders.vdf"
source_dir="${HOME}/.local/share/Steam/steamapps/compatdata"

if [[ ! -f "${vdf}" ]]; then
  exit 0
fi

mkdir -p "${source_dir}"

grep '"path"' "${vdf}" | cut -d'"' -f4 | while IFS= read -r library; do
  target="${library}/steamapps/compatdata"

  if [[ "${library}" == "${HOME}"/* ]] || [[ ! -d "${target}" ]] || [[ -O "${target}" ]]; then
    continue
  fi

  printf '%s\n' --bind "${source_dir}" "${target}"
done
