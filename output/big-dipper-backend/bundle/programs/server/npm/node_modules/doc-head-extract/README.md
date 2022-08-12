## doc-head-extract

extract headings from html string.

input

```
<h2 id="foo">foo</h2>
<p> p... </p>
<h3> bar </h3>
<h2 id="rah">rah <div>...</div> </h2>
```

will get

```
[
  {
    anchor: "foo",
    name: "foo",
    depth: 2,
    sub: [
      {
        anchor: undefined,
        name: "bar",
        depth: 3,
        sub: []
      }
    ]
  },
  {
    anchor: "rah",
    name: "rah ...",
    depth: 2,
    sub: []
  }
]
```

### install

```
npm i doc-head-extract -S
```

### usage

```
import extractHead from 'doc-head-extract'

extractHead('<p> html string... </p>')
```

