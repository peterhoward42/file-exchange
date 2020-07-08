TITLE("Create-File-Share-On-Unspecified-Volume")

CREATES("volume")
size = PARAM("required-size")
candidates = [v for v in GET("volume") if v.space-available > size]
if !candidates:
    vol_id = RUNPLAYBOOK("create-volume", size * 10)
else:
    vol = candidates[0]
RUNPLAYBOOK("create-share", vol, PARAM("share-name"), size)