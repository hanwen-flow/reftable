/*
Copyright 2021 Google LLC

Use of this source code is governed by a BSD-style
license that can be found in the LICENSE file or at
https://developers.google.com/open-source/licenses/bsd
*/

#ifndef DIR_H
#define DIR_H

/* In git, this is declared in dir.h */
int remove_dir_recursively(struct strbuf *path, int flags);

#endif
