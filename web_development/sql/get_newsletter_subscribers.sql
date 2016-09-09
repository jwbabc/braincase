SELECT
  users.uid,
  users.name,
  first_name.value first_name,
  last_name.value last_name,
  users.mail

FROM
  profile_values,
  users

LEFT JOIN
  profile_values first_name
ON
  users.uid = first_name.uid AND
  first_name.fid = 22

LEFT JOIN
  profile_values last_name
ON
  users.uid = last_name.uid AND
  last_name.fid = 23

WHERE
  users.uid = profile_values.uid AND
  users.status = 1 AND
  profile_values.fid = 29 AND
  profile_values.value = 1