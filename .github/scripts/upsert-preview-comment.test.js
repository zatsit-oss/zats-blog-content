// Tests for upsert-preview-comment.js: node --test .github/scripts/
const { test } = require('node:test');
const assert = require('node:assert/strict');
const upsertPreviewComment = require('./upsert-preview-comment');

const BOT = { login: 'github-actions[bot]' };
const HUMAN = { login: 'jdoe' };
const BODY = '<!-- zats-blog-preview -->\n### Aperçu de la PR\n';

// Minimal stand-in for the Octokit client github-script provides.
function fakeGithub(existing) {
  const calls = [];
  const rest = {
    issues: {
      listComments: 'listComments',
      createComment: async (params) => calls.push(['create', params]),
      updateComment: async (params) => calls.push(['update', params]),
    },
  };
  return { calls, rest, paginate: async () => existing };
}

const context = { repo: { owner: 'o', repo: 'r' }, payload: { pull_request: { number: 7 } } };

test('creates the comment when none exists', async () => {
  const github = fakeGithub([]);
  await upsertPreviewComment({ github, context, body: BODY });
  assert.deepEqual(github.calls, [['create', { owner: 'o', repo: 'r', issue_number: 7, body: BODY }]]);
});

test('updates the bot comment that starts with the marker', async () => {
  const github = fakeGithub([
    { id: 1, user: BOT, body: 'Visit the preview URL' },
    { id: 2, user: BOT, body: '<!-- zats-blog-preview -->\nold' },
  ]);
  await upsertPreviewComment({ github, context, body: BODY });
  assert.deepEqual(github.calls, [['update', { owner: 'o', repo: 'r', comment_id: 2, body: BODY }]]);
});

test('ignores a human comment that starts with the marker', async () => {
  const github = fakeGithub([{ id: 3, user: HUMAN, body: '<!-- zats-blog-preview -->\nquoted' }]);
  await upsertPreviewComment({ github, context, body: BODY });
  assert.equal(github.calls[0][0], 'create');
});
