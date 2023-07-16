# excelsed
## What
Excelsed help you replace text in your xlsx file without change any format like font style, underline, strikethrough, color,...etc or lost image.

## Usage
Just require gem and use

```
require 'excelsed'

Excelsed.new("test/fixtures/example.xlsx", { VARIABLE_A: 'something want replace to'}, 'path/of/output/dir').perform
```
