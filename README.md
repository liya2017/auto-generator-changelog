[![License](https://img.shields.io/github/license/heinrichreimer/action-github-changelog-generator.svg?style=flat-square)](LICENSE)
[![Last commit](https://img.shields.io/github/last-commit/heinrichreimer/action-github-changelog-generator.svg?style=flat-square)](https://github.com/heinrichreimer/action-github-changelog-generator/commits)
[![Latest tag](https://img.shields.io/github/tag/heinrichreimer/action-github-changelog-generator.svg?style=flat-square)](https://github.com/heinrichreimer/action-github-changelog-generator/releases)
[![Issues](https://img.shields.io/github/issues/heinrichreimer/action-github-changelog-generator.svg?style=flat-square)](https://github.com/heinrichreimer/action-github-changelog-generator/issues)
[![Pull requests](https://img.shields.io/github/issues-pr/heinrichreimer/action-github-changelog-generator.svg?style=flat-square)](https://github.com/heinrichreimer/action-github-changelog-generator/pulls)

# ✏️ action-github-changelog-generator

Automatically generate change log from your tags, issues, labels and pull requests on GitHub,
using [github-changelog-generator](https://github.com/github-changelog-generator/github-changelog-generator)'s
[Docker image](https://github.com/github-changelog-generator/docker-github-changelog-generator).

This action also makes the changelog available to other actions as [output](#outputs).

## Example usage

```yaml
name: Changelog
on:
  release:
    types:
      - created
jobs:
  changelog:
    runs-on: ubuntu-20.04
    steps:
      - name: "✏️ Generate release changelog"
        uses: heinrichreimer/github-changelog-generator-action@v2.3
        with:
          token: ${{ secrets.GITHUB_TOKEN }} 
```

## Inputs

| Name | Description | Default |
|---|---|---|
| `repo` | Target GitHub repo in the form of organization/repository. | [inherit] |
| `user` | Username of the owner of target GitHub repo. | [inherit] |
| `project` | Name of project on GitHub. | [inherit] |
| `token` | To make more than 50 requests per hour your GitHub token is required. | [inherit] |
| `output` | Output file. | [inherit] |
| `base` | Optional base file to append generated changes to. | [inherit] |
| `headerLabel` | Set up custom header label. | [inherit] |
| `configureSections` | Define your own set of sections which overrides all default sections. | [inherit] |
| `addSections` | Add new sections but keep the default sections. | 
| `author` | Add author of pull request at the end. | [inherit] |
| `compareLink` | Include compare link (Full Changelog) between older version and newer version. | [inherit] |
| `excludeTags` | Changelog will exclude specified tags. | [inherit] |
| `excludeTagsRegex` | Apply a regular expression on tag names so that they can be excluded. | [inherit] |
| `sinceTag` | Changelog will start after specified tag. | [inherit] |
| `dueTag` | Changelog will end before specified tag. | [inherit] |
| `releaseUrl` | The URL to point to for release links, in printf format (with the tag as variable). | [inherit] |
| `verbose` | Run verbosely. | [inherit] |
| `onlyLastTag` | Changelog will only show last tag. | `false` |
| `stripHeaders` | Strip headers and only show changes. | `false` |
| `stripGeneratorNotice` | Strip generator notice. | `false` |

Most inputs inherit their defaults from 
[github-changelog-generator][inherit].

## Outputs

| Name | Description |
|---|---|
| `changelog` | Contents of generated change log. |

[inherit]: https://github.com/github-changelog-generator/github-changelog-generator/wiki/Advanced-change-log-generation-examples#additional-options "Inherited from github-changelog-generator."
