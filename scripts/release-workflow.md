# Release workflow

The GitHub release workflow uses the release tag name as the XCFramework version.

To publish a new version:

1. Create a new git tag locally:

```bash
git tag -a 9.9.9 -m "Release 9.9.9"
git push origin --tags
```

2. Create a GitHub Release for the `9.9.9` tag.

3. GitHub Actions will run `.github/workflows/release.yml`, build the XCFramework package, and upload `NICardManagementSDK-9.9.9.zip` as a release asset.

You can also create the release with the GitHub CLI:

```bash
gh release create 9.9.9 --title "9.9.9" --notes "Release NICardManagementSDK 9.9.9"
```
