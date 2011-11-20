---
title:      Resources
created_at: 2011-08-31 00:39:58.996830 -07:00
filter:
  - erb
  - markdown
---

<h1><%= @page.title %></h1>

<h2>Software</h2>

<ul class="full-size">

  <li>
    <a href="https://github.com/pieter/gitx/wiki/">GitX (original version)</a>
    <div class="reading-note">
      Development of this stalled out at 0.7.1, and the README now points at the GitX (L) fork, linked below.  I still use this one because it's super fast, and I'm comfortable doing branch manipulation on the command line.
    </div>
  </li>

  <li>
    <a href="http://gitx.laullon.com/">GitX (L)</a>
    <div class="reading-note">
      This fork has added some nice features.  However, it appears to be considerably slower when accessing a repo with several years of commits, so I'm sticking with the original project for now.  (I've heard good things about the <a href="https://github.com/brotherbard/gitx">brotherbard fork</a>, but development on that also appears to have stalled.) Thanks to <%= twitter_user('hugocf') %> for directing me to this fork.
    </div>
  </li>

  <li>
    <a href="http://jonas.nitro.dk/tig/">Tig: text-mode interface for git</a> by <a href="http://jonasfonseca.com/">Jonas Fonseca</a>
    <div class="reading-note">
      Also suggested by <a href="http://markscholtz.com/">Mark Scholtz</a>, this is a text-mode UI that gives you pretty (but still text-based) views of many of the same things that GitX does.  I personally don't have a lot of use for this, but for those of you who really really love your CLI (or your screen readers!), this might fit your working style a bit better.
    </div>
  </li>

</ul>

<h2>Free Stuff About Git</h2>

<ul class="full-size">
  <li>
    <a href="http://tom.preston-werner.com/2009/05/19/the-git-parable.html">The Git Parable</a>, 2009 blog post by Tom&nbsp;Preston-Werner
    <div class="reading-note">
      Explains why you might want to use Git, and why it has some of the features it has.  At end, provides links to a few other resources that may be useful.
    </div>
  </li>

  <li>
    <a href="http://hginit.com/00.html">Subversion Re-Education</a> page on a Mercurial tutorial site by Joel&nbsp;Spolsky
    <div class="reading-note">
      Mercurial is a different distributed version control system, but this one page is incredibly useful if you're coming to Git from Subversion or another centralized system.
    </div>
  </li>

  <li>
    <a href="http://tomayko.com/writings/the-thing-about-git">The Thing About Git</a> 2008 blog post by Ryan&nbsp;Tomayko
    <div class="reading-note">
      One of the best pieces I've ever read about Git.  Explains a lot, especially what the index is.
    </div>
  </li>

  <li>
    <a href="http://nfarina.com/post/9868516270/git-is-simpler">Git is Simpler Than You Think</a>, 2011 blog post by Nick&nbsp;Farina
    <div class="reading-note">
      Chatty blog post with lots of entertaining pictures.  You'll hardly notice you're learning stuff.
    </div>
  </li>

  <li>
    <a href="http://blip.tv/open-source-developers-conference/git-for-ages-4-and-up-4460524">Git for Ages 4 and Up</a> 2010 Flash video by Michael&nbsp;Schwern
    <div class="reading-note">
      If you've got 45 minutes to spare, this is a great talk.  Schwern engages your kinesthetic and spatial reasoning faculties to help you understand what Git is doing.
    </div>
  </li>

  <li>
    <a href="http://programblings.com/2008/06/07/the-illustrated-guide-to-recovering-lost-commits-with-git/">The Illustrated Guide to Recovering Lost Commits With Git</a>, 2008 blog post by Mathieu Martin
    <div class="reading-note">
      Sometimes the best way to learn how to fix something is to break it on purpose.  Arlo Belshee once told me that when he joins a new team, he likes to force them into a failure mode as quickly as he can, just so he can build trust in their collective ability to recover from it.  In that spirit, Mathieu walks you through "losing" work in Git, and then shows you how to get it back again.  Great stuff.
    </div>
  </li>

  <li>
    <a href="http://gitimmersion.com/">Git Immersion</a> by EdgeCase Consulting
    <div class="reading-note">
      This one was suggested by reader <a href="http://markscholtz.com/">Mark Scholtz</a>.  I haven't gone through it myself, but at first glance this looks like an amazingly detailed, well supported step-by-step tutorial that starts from the very basics and goes on through some very advanced topics.  Thanks, Mark!
    </div>
  </li>

  <li>
    <a href="http://progit.org/">Pro Git</a>, occasional blog and 2009 book by Scott&nbsp;Chacon
    <div class="reading-note">
      I have to admit that I haven't actually read this one&mdash;it was suggested by <a href="http://jasonseifer.com/">Jason Seifer</a>.  Looks like an interesting blog, and as I've said elsewhere on the site, Scott Chacon's knowledge of Git is... impressive.  <strong>(Note:  free blog promoting for-pay book, so I'm listing it in the free section.)</strong>
    </div>
  </li>

  <li>
    <a href="http://johnwilger.com/2011/01/production-release-workflow-with-git.html">Production Release Workflow With Git</a>, a blog post by John&nbsp;Wilger
    <div class="reading-note">
      In January 2011, my manager wrote up this description of the rebase-oriented workflow we'd been using on our team for (then) several months.  We've since discovered some subtle problems with this approach and are moving toward a <a href="http://continuousdelivery.com/">continuous delivery</a> setup.  While I might not recommend this workflow now, it's an interesting example of how rewrites to shared history (generally considered extremely disruptive) can work quite well as long as the entire team expects them and has the skills to cope with issues when they arise (which is not as often as you might think).
    </div>
  </li>
</ul>

<h2>Stuff About Git You Should Pay For</h2>

<ul class="full-size">
  <li>
    <a href="http://peepcode.com/products/git">Peepcode screencast on Git</a> ($12)
    <div class="reading-note">
      I found this helpful when I was completely new to Git.  Haven't revisited it in a few years.
    </div>
  </li>

  <li>
    <a href="https://peepcode.com/products/git-internals-pdf">Git Internals PDF</a> by Scott&nbsp;Chacon (also $12 via Peepcode)
    <div class="reading-note">
      More detail than you could ever possibly want on how Git works.  I've read maybe half of it.  It's incredible.
    </div>
  </li>
</ul>

<h2>Graph Theory Awesomeness</h2>

<ul class="full-size">
  <li>
    <a href="http://www.jamisbuck.org/presentations/rubyconf2011/index.html">"Algorithm" is not a !@%#$@ 4-Letter Word</a>, RubyConf 2011 slides by Jamis&nbsp;Buck
    <div class="reading-note">
      Won't teach you a thing about Git&mdash;or will it?  Either way, if you're not 5 IQ points smarter by the end, I'll personally refund your purchase price.
    </div>
  </li>
</ul>
