$(function() {
  $("a#toggle-actions").click(function() { $('.action').toggle(); return false; });
  $("a#toggle-assertions").click(function() { $('.assertion').toggle(); return false; });
  $("a#toggle-links").click(function() { $('.game-link').toggle(); return false; });
});
