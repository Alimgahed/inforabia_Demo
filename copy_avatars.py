import shutil
import glob
import os

source_dir = "/Users/alimegahed/.gemini/antigravity/brain/abf71484-677d-4252-87b7-2f0393d7fe2b/"
dest_dir = "/Users/alimegahed/Downloads/inforabia-431bd2b5503dd640ea0cf7ab6ec9bac27582536f/assets/images/team/"

for img in glob.glob(source_dir + "avatar_*.png"):
    filename = os.path.basename(img)
    name = filename.split('_')[1] + ".png"
    print(f"Copying {img} to {dest_dir + name}")
    shutil.copy(img, dest_dir + name)
