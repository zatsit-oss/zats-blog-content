---
slug: Angular-Signals-best-practices
title: Angular Signals: best practices
authors: [nlefebvre]
tags: 
  - "angular"
  - "web"
---

Les bonnes pratique sur Angular Signal

<!-- truncate -->

I still don’t want to encourage you to use effect(), but I’ll give you advice on how to use it as safely as possible:

The function you provide to effect() should be as small as possible. This way it will be easier to read and spot erroneous behavior.
Read signals first, then wrap the rest of the effect into untracked():

```
effect(() => {
  // reading the signals we need
  const a = this.a();
  const b = this.b();
  
  untracked(() => {
    // rest of the code is here - this code should not
    // modify the signals we read above!
    if (a > b) {
      document.title = 'Ok';
    }
  });
});
```