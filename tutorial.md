---
---

# Tutorial

{: class="blue mb-6"}
> _Adapted from the [jq tutorial][jq_tutorial]_

GitHub has a JSON API, so let's play with that.  This URL gets us the last five
commits from the [Retrospring repo][retrospring_repo].

```sh
curl 'https://api.github.com/repos/Retrospring/retrospring/commits?per_page=5'
```

<details markdown="1">
<summary>Show result</summary>

```json
[
  {
    "sha": "b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "node_id": "C_kwDOAk1rYNoAKGI2YzQyMjY0YTY2NTI2NzRkZWI2NmU3ZGQ5Yjk1YTc4NGZlYThlNDA",
    "commit": {
      "author": {
        "name": "Georg Gadinger",
        "email": "nilsding@nilsding.org",
        "date": "2022-07-09T11:40:29Z"
      },
      "committer": {
        "name": "GitHub",
        "email": "noreply@github.com",
        "date": "2022-07-09T11:40:29Z"
      },
      "message": "Merge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch",
      "tree": {
        "sha": "eea1f8de390ac9f9adadbaecfc367ec5bacff33e",
        "url": "https://api.github.com/repos/Retrospring/retrospring/git/trees/eea1f8de390ac9f9adadbaecfc367ec5bacff33e"
      },
      "url": "https://api.github.com/repos/Retrospring/retrospring/git/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
      "comment_count": 0,
      "verification": {
        "verified": true,
        "reason": "valid",
        "signature": "-----BEGIN PGP SIGNATURE-----\n\nwsBcBAABCAAQBQJiyWktCRBK7hj4Ov3rIwAAhYYIAIAOf3QibMAo38jRRSqmFgf0\nTAwJmW01Vkp9dAcQgUvMAwopyN+w4pFt3JgXh4hXIGP7VMeU89KAt4SmQ1WB7PIo\nHpyP0aGLO/FSiFKu/Jp+rXE2yqo02T3nxqu4xctbL+JScXpE/InYokcqfrcqAvAp\n3zk2lgzzP7QIix0mwFv5PN0F2sCjHpucetqXeQl7snLUs/VTf4A96Th/2Ut/aSdE\nP99iY+gbdUI1if1EoRC95z53mDimTIvJXnG8FIUa6eR1bsosdHEP8zxJW2LV/iah\n3p3at32xgzyGCIeqC3ad7Ynv19EFTGqMMk+bl02RJ2TcvW0BjUEiKvI8g8zJfuM=\n=p6EV\n-----END PGP SIGNATURE-----\n",
        "payload": "tree eea1f8de390ac9f9adadbaecfc367ec5bacff33e\nparent 4f1260bc044f731c9b5c038a747d3af0ae5c7241\nparent 3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd\nauthor Georg Gadinger <nilsding@nilsding.org> 1657366829 +0200\ncommitter GitHub <noreply@github.com> 1657366829 +0200\n\nMerge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch"
      }
    },
    "url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "html_url": "https://github.com/Retrospring/retrospring/commit/b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "comments_url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40/comments",
    "author": {
      "login": "nilsding",
[...]
```
{%- comment -%} workaround to make Kate's syntax highlighting happy again
}]
```
{%- endcomment %}

</details>

GitHub returns nicely formatted JSON.  For servers that don't, it can be
helpful to pipe the response through rj to pretty-print it.  The simplest
usage of rj is to not pass any expressions to it at all; rj takes the input
and prints it in a formatted way.

```sh
curl 'https://api.github.com/repos/Retrospring/retrospring/commits?per_page=5' | rj
```

<details markdown="1">
<summary>Show result</summary>

```json
[
  {
    "sha": "b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "node_id": "C_kwDOAk1rYNoAKGI2YzQyMjY0YTY2NTI2NzRkZWI2NmU3ZGQ5Yjk1YTc4NGZlYThlNDA",
    "commit": {
      "author": {
        "name": "Georg Gadinger",
        "email": "nilsding@nilsding.org",
        "date": "2022-07-09T11:40:29Z"
      },
      "committer": {
        "name": "GitHub",
        "email": "noreply@github.com",
        "date": "2022-07-09T11:40:29Z"
      },
      "message": "Merge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch",
      "tree": {
        "sha": "eea1f8de390ac9f9adadbaecfc367ec5bacff33e",
        "url": "https://api.github.com/repos/Retrospring/retrospring/git/trees/eea1f8de390ac9f9adadbaecfc367ec5bacff33e"
      },
      "url": "https://api.github.com/repos/Retrospring/retrospring/git/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
      "comment_count": 0,
      "verification": {
        "verified": true,
        "reason": "valid",
        "signature": "-----BEGIN PGP SIGNATURE-----\n\nwsBcBAABCAAQBQJiyWktCRBK7hj4Ov3rIwAAhYYIAIAOf3QibMAo38jRRSqmFgf0\nTAwJmW01Vkp9dAcQgUvMAwopyN+w4pFt3JgXh4hXIGP7VMeU89KAt4SmQ1WB7PIo\nHpyP0aGLO/FSiFKu/Jp+rXE2yqo02T3nxqu4xctbL+JScXpE/InYokcqfrcqAvAp\n3zk2lgzzP7QIix0mwFv5PN0F2sCjHpucetqXeQl7snLUs/VTf4A96Th/2Ut/aSdE\nP99iY+gbdUI1if1EoRC95z53mDimTIvJXnG8FIUa6eR1bsosdHEP8zxJW2LV/iah\n3p3at32xgzyGCIeqC3ad7Ynv19EFTGqMMk+bl02RJ2TcvW0BjUEiKvI8g8zJfuM=\n=p6EV\n-----END PGP SIGNATURE-----\n",
        "payload": "tree eea1f8de390ac9f9adadbaecfc367ec5bacff33e\nparent 4f1260bc044f731c9b5c038a747d3af0ae5c7241\nparent 3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd\nauthor Georg Gadinger <nilsding@nilsding.org> 1657366829 +0200\ncommitter GitHub <noreply@github.com> 1657366829 +0200\n\nMerge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch"
      }
    },
    "url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "html_url": "https://github.com/Retrospring/retrospring/commit/b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "comments_url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40/comments",
    "author": {
      "login": "nilsding",
[...]
```
{%- comment -%} workaround to make Kate's syntax highlighting happy again
}]
```
{%- endcomment %}

</details>

We can use rj to extract just the first commit.  You can do that in many ways,
for example by using the [`Enumerable#first` method][mruby_enumerable_first],
or in this case using [`Array#[]`][mruby_array_element].

```sh
curl 'https://api.github.com/repos/Retrospring/retrospring/commits?per_page=5' | rj '.first'

# this works too:
curl 'https://api.github.com/repos/Retrospring/retrospring/commits?per_page=5' | rj '[0]'
```

<details markdown="1">
<summary>Show result</summary>

```json
{
  "sha": "b6c42264a6652674deb66e7dd9b95a784fea8e40",
  "node_id": "C_kwDOAk1rYNoAKGI2YzQyMjY0YTY2NTI2NzRkZWI2NmU3ZGQ5Yjk1YTc4NGZlYThlNDA",
  "commit": {
    "author": {
      "name": "Georg Gadinger",
      "email": "nilsding@nilsding.org",
      "date": "2022-07-09T11:40:29Z"
    },
    "committer": {
      "name": "GitHub",
      "email": "noreply@github.com",
      "date": "2022-07-09T11:40:29Z"
    },
    "message": "Merge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch",
    "tree": {
      "sha": "eea1f8de390ac9f9adadbaecfc367ec5bacff33e",
      "url": "https://api.github.com/repos/Retrospring/retrospring/git/trees/eea1f8de390ac9f9adadbaecfc367ec5bacff33e"
    },
    "url": "https://api.github.com/repos/Retrospring/retrospring/git/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
    "comment_count": 0,
    "verification": {
      "verified": true,
      "reason": "valid",
      "signature": "-----BEGIN PGP SIGNATURE-----\n\nwsBcBAABCAAQBQJiyWktCRBK7hj4Ov3rIwAAhYYIAIAOf3QibMAo38jRRSqmFgf0\nTAwJmW01Vkp9dAcQgUvMAwopyN+w4pFt3JgXh4hXIGP7VMeU89KAt4SmQ1WB7PIo\nHpyP0aGLO/FSiFKu/Jp+rXE2yqo02T3nxqu4xctbL+JScXpE/InYokcqfrcqAvAp\n3zk2lgzzP7QIix0mwFv5PN0F2sCjHpucetqXeQl7snLUs/VTf4A96Th/2Ut/aSdE\nP99iY+gbdUI1if1EoRC95z53mDimTIvJXnG8FIUa6eR1bsosdHEP8zxJW2LV/iah\n3p3at32xgzyGCIeqC3ad7Ynv19EFTGqMMk+bl02RJ2TcvW0BjUEiKvI8g8zJfuM=\n=p6EV\n-----END PGP SIGNATURE-----\n",
      "payload": "tree eea1f8de390ac9f9adadbaecfc367ec5bacff33e\nparent 4f1260bc044f731c9b5c038a747d3af0ae5c7241\nparent 3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd\nauthor Georg Gadinger <nilsding@nilsding.org> 1657366829 +0200\ncommitter GitHub <noreply@github.com> 1657366829 +0200\n\nMerge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch"
    }
  },
  "url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40",
  "html_url": "https://github.com/Retrospring/retrospring/commit/b6c42264a6652674deb66e7dd9b95a784fea8e40",
  "comments_url": "https://api.github.com/repos/Retrospring/retrospring/commits/b6c42264a6652674deb66e7dd9b95a784fea8e40/comments",
  "author": {
    "login": "nilsding",
    "id": 1809170,
    "node_id": "MDQ6VXNlcjE4MDkxNzA=",
    "avatar_url": "https://avatars.githubusercontent.com/u/1809170?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/nilsding",
    "html_url": "https://github.com/nilsding",
    "followers_url": "https://api.github.com/users/nilsding/followers",
    "following_url": "https://api.github.com/users/nilsding/following{/other_user}",
    "gists_url": "https://api.github.com/users/nilsding/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/nilsding/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/nilsding/subscriptions",
    "organizations_url": "https://api.github.com/users/nilsding/orgs",
    "repos_url": "https://api.github.com/users/nilsding/repos",
    "events_url": "https://api.github.com/users/nilsding/events{/privacy}",
    "received_events_url": "https://api.github.com/users/nilsding/received_events",
    "type": "User",
    "site_admin": false
  },
  "committer": {
    "login": "web-flow",
    "id": 19864447,
    "node_id": "MDQ6VXNlcjE5ODY0NDQ3",
    "avatar_url": "https://avatars.githubusercontent.com/u/19864447?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/web-flow",
    "html_url": "https://github.com/web-flow",
    "followers_url": "https://api.github.com/users/web-flow/followers",
    "following_url": "https://api.github.com/users/web-flow/following{/other_user}",
    "gists_url": "https://api.github.com/users/web-flow/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/web-flow/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/web-flow/subscriptions",
    "organizations_url": "https://api.github.com/users/web-flow/orgs",
    "repos_url": "https://api.github.com/users/web-flow/repos",
    "events_url": "https://api.github.com/users/web-flow/events{/privacy}",
    "received_events_url": "https://api.github.com/users/web-flow/received_events",
    "type": "User",
    "site_admin": false
  },
  "parents": [
    {
      "sha": "4f1260bc044f731c9b5c038a747d3af0ae5c7241",
      "url": "https://api.github.com/repos/Retrospring/retrospring/commits/4f1260bc044f731c9b5c038a747d3af0ae5c7241",
      "html_url": "https://github.com/Retrospring/retrospring/commit/4f1260bc044f731c9b5c038a747d3af0ae5c7241"
    },
    {
      "sha": "3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd",
      "url": "https://api.github.com/repos/Retrospring/retrospring/commits/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd",
      "html_url": "https://github.com/Retrospring/retrospring/commit/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd"
    }
  ]
}
```

</details>

For the rest of the examples, I'll leave out the curl command - it's not going
to change.

There's a lot of info we don't care about there, so we'll restrict it down to
the most interesting fields.

```sh
rj '.first' '{ message: item.dig("commit", "message"), name: item.dig("commit", "committer", "name") }'
```

<details markdown="1">
<summary>Show result</summary>

```json
{
  "message": "Merge pull request #507 from Retrospring/depperterbot\n\nDependabot merge branch",
  "name": "GitHub"
}
```

</details>

Chaining expressions in rj is done by passing another expression after one.
In case you don't want to chain another method on the previous result, but
return another one entirely you can do that too.  To access the previous
result you can use the `item` variable.

I also used the used the [`Hash#dig` method][mruby_hash_dig] to lazily access
nested attributes.  However since expressions are just Ruby code you can even
do the following:

```sh
# Here I assigned the contents of the `commit` field to a temporary variable
# which I then use in the resulting hash.  The result is the same as before.
rj '.first' 'commit = item["commit"]; { message: commit["message"], name: commit.dig("committer", "name") }'
```

But I'm not done quite yet, I would like to only get the first line of a
commit message.  This can be achieve by using the
[`String#split` method][mruby_string_split] along with one of the methods we
used earlier to get the first element of an array:

```sh
rj '.first' '{ message: item.dig("commit", "message").split("\n").first, name: item.dig("commit", "committer", "name") }'
```

<details markdown="1">
<summary>Show result</summary>

```json
{
  "message": "Merge pull request #507 from Retrospring/depperterbot",
  "name": "GitHub"
}
```

</details>

That's more like it.  Let's apply that to all our commits:

```sh
rj '.map { |x| { message: x.dig("commit", "message").split("\n").first, name: x.dig("commit", "committer", "name") } }'
```

<details markdown="1">
<summary>Show result</summary>

```json
[
  {
    "message": "Merge pull request #507 from Retrospring/depperterbot",
    "name": "GitHub"
  },
  {
    "message": "Bump bootstrap_form from 5.0.0 to 5.1.0",
    "name": "Andreas Nedbal"
  },
  {
    "message": "remove fix_* tasks as we ensured we won't need them anymore a long time ago",
    "name": "Georg Gadinger"
  },
  {
    "message": "Remove unneeded Rake tasks",
    "name": "Georg Gadinger"
  },
  {
    "message": "Bump actions/setup-node from 1 to 3",
    "name": "Georg Gadinger"
  }
]
```

</details>

The [`Enumerable#map` method][mruby_enumerable_collect] (which is also
accessible as `Enumerable#collect`) applies the value returned of the block
passed to it.  A Ruby block is essentially an anonymous function that does
something based on the parameters given (in the example above I named the
parameter `x`) and returns a new value.  `.map` calls this function on each
element of the array (or object!) and returns a new array with the resulting
values.

Next, let's try getting the URLs of the parent commits out of the API results
as well.  In each commit, the GitHub API includes information about "parent"
commits.  There can be one or many.

```json
"parents": [
  {
    "sha": "4f1260bc044f731c9b5c038a747d3af0ae5c7241",
    "url": "https://api.github.com/repos/Retrospring/retrospring/commits/4f1260bc044f731c9b5c038a747d3af0ae5c7241",
    "html_url": "https://github.com/Retrospring/retrospring/commit/4f1260bc044f731c9b5c038a747d3af0ae5c7241"
  },
  {
    "sha": "3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd",
    "url": "https://api.github.com/repos/Retrospring/retrospring/commits/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd",
    "html_url": "https://github.com/Retrospring/retrospring/commit/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd"
  }
]
```

We want to pull out all of the `"html_url"` fields inside that array of parent
commits and make a simple list of strings to go along with the `"message"` and
`"author"` fields we already have.

```sh
rj '.map { |x| { message: x.dig("commit", "message").split("\n").first, name: x.dig("commit", "committer", "name"), parents: x["parents"].map { |parent| parent["html_url"] } } }'
```

<details markdown="1">
<summary>Show result</summary>

```json
[
  {
    "message": "Merge pull request #507 from Retrospring/depperterbot",
    "name": "GitHub",
    "parents": [
      "https://github.com/Retrospring/retrospring/commit/4f1260bc044f731c9b5c038a747d3af0ae5c7241",
      "https://github.com/Retrospring/retrospring/commit/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd"
    ]
  },
  {
    "message": "Bump bootstrap_form from 5.0.0 to 5.1.0",
    "name": "Andreas Nedbal",
    "parents": [
      "https://github.com/Retrospring/retrospring/commit/84d77704b11a19c17b370808f9ccab8ac384b4e2"
    ]
  },
  {
    "message": "remove fix_* tasks as we ensured we won't need them anymore a long time ago",
    "name": "Georg Gadinger",
    "parents": [
      "https://github.com/Retrospring/retrospring/commit/31e9d7ac8059fbf7148ee49da1282ca6a93a536a"
    ]
  },
  {
    "message": "Remove unneeded Rake tasks",
    "name": "Georg Gadinger",
    "parents": [
      "https://github.com/Retrospring/retrospring/commit/5155b6dee761ba538e8f8c2b07773abc672dbaa2"
    ]
  },
  {
    "message": "Bump actions/setup-node from 1 to 3",
    "name": "Georg Gadinger",
    "parents": [
      "https://github.com/Retrospring/retrospring/commit/18386e88ed7379af9fbc0260b7304491a61d5ae8"
    ]
  }
]
```

</details>

Here we're making a new object as before, but this time the `parents` field is
being set to `x["parents"].map { |parent| parent["html_url"] }`, which
collects all of the parent commit URLs defined in the parents object.

Finally, we can tell rj to output our transformed object as a Ruby hash by
setting `-o ruby`.

```sh
rj -o ruby '.map { |x| { message: x.dig("commit", "message").split("\n").first, name: x.dig("commit", "committer", "name"), parents: x["parents"].map { |parent| parent["html_url"] } } }'
```

<details markdown="1">
<summary>Show result</summary>

```ruby
[
  {
    :message => "Merge pull request #507 from Retrospring/depperterbot",
    :name => "GitHub",
    :parents => [
      "https://github.com/Retrospring/retrospring/commit/4f1260bc044f731c9b5c038a747d3af0ae5c7241",
      "https://github.com/Retrospring/retrospring/commit/3e6eb346c45b66ece3c8c0c32ef2d797d52b1cfd",
    ],
  },
  {
    :message => "Bump bootstrap_form from 5.0.0 to 5.1.0",
    :name => "Andreas Nedbal",
    :parents => [
      "https://github.com/Retrospring/retrospring/commit/84d77704b11a19c17b370808f9ccab8ac384b4e2",
    ],
  },
  {
    :message => "remove fix_* tasks as we ensured we won't need them anymore a long time ago",
    :name => "Georg Gadinger",
    :parents => [
      "https://github.com/Retrospring/retrospring/commit/31e9d7ac8059fbf7148ee49da1282ca6a93a536a",
    ],
  },
  {
    :message => "Remove unneeded Rake tasks",
    :name => "Georg Gadinger",
    :parents => [
      "https://github.com/Retrospring/retrospring/commit/5155b6dee761ba538e8f8c2b07773abc672dbaa2",
    ],
  },
  {
    :message => "Bump actions/setup-node from 1 to 3",
    :name => "Georg Gadinger",
    :parents => [
      "https://github.com/Retrospring/retrospring/commit/18386e88ed7379af9fbc0260b7304491a61d5ae8",
    ],
  },
]
```

</details>



[retrospring_repo]: https://github.com/Retrospring/retrospring
[jq_tutorial]: https://stedolan.github.io/jq/tutorial/
[mruby_enumerable_first]: https://mruby.org/docs/api/Enumerable.html#first-instance_method
[mruby_array_element]: https://mruby.org/docs/api/Array.html#[]-instance_method
[mruby_hash_dig]: https://mruby.org/docs/api/Hash.html#dig-instance_method
[mruby_string_split]: https://mruby.org/docs/api/String.html#split-instance_method
[mruby_enumerable_collect]: https://mruby.org/docs/api/Enumerable.html#collect-instance_method
