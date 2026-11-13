// Posts the preview comment on the pull request, or updates the one posted by
// an earlier run, so a PR keeps a single comment however many times it is pushed.
//
// Called from actions/github-script, which provides `github` and `context`.
// `body` is the output of preview-comment.sh: its first line is the hidden
// marker that identifies the comment, so the marker is defined in one place.

const BOT_LOGIN = 'github-actions[bot]';

module.exports = async function upsertPreviewComment({ github, context, body }) {
  const marker = body.split('\n', 1)[0];
  const { owner, repo } = context.repo;
  const issue_number = context.payload.pull_request.number;

  const comments = await github.paginate(github.rest.issues.listComments, { owner, repo, issue_number });
  // Only our own comment: GITHUB_TOKEN cannot edit someone else's, and a human
  // quoting the marker must not hijack it.
  const previous = comments.find((c) => c.user?.login === BOT_LOGIN && c.body?.startsWith(marker));

  if (previous) {
    await github.rest.issues.updateComment({ owner, repo, comment_id: previous.id, body });
  } else {
    await github.rest.issues.createComment({ owner, repo, issue_number, body });
  }
};
