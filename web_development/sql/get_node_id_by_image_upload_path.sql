# sites/default/files/show212fleamarketfinds.jpg - 3589
# sites/default/files/show211storagesolutions.jpg - 3588
# sites/default/files/koslowfamily.jpg - 3574
# sites/default/files/fiftysomething.jpg - 3684
# sites/default/files/darkshadows.jpg - 3685
# sites/default/files/cardinalrule.jpg - 3683
 
# sites/default/files/78397858.jpg - not found
# sites/default/files/78033759.jpg - 3688
# sites/default/files/75402589_0.jpg - 3679
# sites/default/files/132048341.jpg - 3680
# sites/default/files/110935726.jpg - 3681

# field_slideshow_image - nid, field_slideshow_imae_fid
# files - fid

SELECT
  content_field_slideshow_image.nid
FROM
files,
  content_field_slideshow_image
WHERE
  content_field_slideshow_image.field_slideshow_image_fid = files.fid AND
  files.filepath = 'sites/default/files/110935726.jpg';

SELECT
  *
FROM
  files
WHERE
  files.filepath = 'sites/default/files/show212fleamarketfinds.jpg';