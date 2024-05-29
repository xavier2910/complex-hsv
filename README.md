# complex-hsv

Graph complex functions using hsv colors.

The idea here is we can use saturation and hue as a sort of polar coordinates
for the input complex plane, and then a conventional x-y plane for the output,
to visualize an entire complex function without multiple coordinate planes and
annoying little arrows. Perhaps more robust systems exist; I'm not well versed
in the study of complex functions, but maybe this will be helpful.

Still very much in early stages. A lot of stack template dummy code. Which, helpfully,
came with instructions:

## Execute

* Run `stack exec -- complex-hsv-exe` to see "We're inside the application!"
* With `stack exec -- complex-hsv-exe --verbose` you will see the same message, with more logging.

## Run tests

`stack test`
