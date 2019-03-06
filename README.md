# delphi-kml
A little experiment with reading KML (Keyhole Markup Language) files in Delphi, as well as writing them to binary form for faster loading.

The experiment is based on the free KML file of the Dutch postal code map (PC4), as offered by Indra:
https://indra.netlify.com/blog/2017/09/17/gratis-postcodekaart.html
which is not included in the repository. Download it, and store it as PC4.kml in the project's `Source` folder.

Mind, this is not a generic, full fledged KML loader and viewer!

Currently it would look something like this, and it doesn't yet have any zooming or other interaction possibilities.

![Screenshot of test application](Doc/img/screenshot.png)

