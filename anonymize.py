import os, sys, re, shutil


zipped_file_name = sys.argv[1]


cwd = os.getcwd()
export_dir = "/tmp/test/"
textfile = export_dir + "/content.xml"

def unzip_file(orig_file) :
  print(orig_file)
  shutil.unpack_archive(zipped_file_name, export_dir, 'zip')

  print(export_dir)


def replace_text(filename, regexp, replace) :
  ''' opens the file ad substitutes
  the corresponding string'''

  f = open(filename, 'r')

  # regexp = "r" + "\"" + regexp + "\""

  print("replace " + regexp)
  print(f"with: {replace}")


  # setting flag and index to 0
  flag = 0
  index = 0

  readfile = f.read()
  search_replace = re.sub(regexp, replace, readfile)

  f.close()

  f = open(filename, 'w')

  f.write(search_replace)

  f.close()

  print(f"I have changed {regexp} with {replace} in {filename}")

def rezip() :

  anon_textfile = cwd + "/_anon_" + zipped_file_name

  # Recreate a version of the file with the new content in it
  shutil.make_archive(anon_textfile, "zip", export_dir)

  anon_textfile_zip = anon_textfile + ".zip"


  # Rename it to the original extension FIXME: this is a hack

  os.rename(anon_textfile_zip, anon_textfile)

  # function returns the name of the changed file
  return anon_textfile

unzip_file(zipped_file_name)

replace_text(textfile, "Carlo Piana", "fuffa")

anonymized = rezip()

print(f"file is now in {anonymized}")


print("Bye")