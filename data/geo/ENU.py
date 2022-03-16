import pymap3d as pm

# the local coordinate origin (ICO, OS)
lat0 = 52.287690 # deg
lng0 = 8.018690  # deg
alt0 = 63        # meters

print("ICO ( lat:", lat0, "lng:", lng0, "alt:", alt0, ")")

# POI (DFKI, OS)
lat1 = 52.287863 # deg
lng1 = 8.027347  # deg
alt1 = 63        # meters

print("DFKI ( lat:", lat1, "lng:", lng1, "alt:", alt1, ")")

# (transform (lat1,lng1,alt1) to ENU with origin (lat0,lng0,alt0))
print("ENU:", pm.geodetic2enu(lat1, lng1, alt1, lat0, lng0, alt0))
