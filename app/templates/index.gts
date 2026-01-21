import { LinkTo } from '@ember/routing';

import { Button } from 'ember-learning/components/ui/button';
import { Badge } from 'ember-learning/components/ui/badge';
import { ThemeSwitcher } from 'ember-learning/components/theme-switcher';
import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
} from 'ember-learning/components/ui/card';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from 'ember-learning/components/ui/table';
import { Separator } from 'ember-learning/components/ui/separator';
import {
  exercises,
  prerequisites,
  learningCategories,
  techStack,
  links,
} from 'ember-learning/data/course-data';

<template>
  <div class="min-h-screen bg-background">
    {{! Navigation }}
    <nav class="bg-card border-b sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <div class="flex items-center space-x-3">
              <div class="w-10 h-10 bg-gradient-to-br from-orange-500 to-red-600 rounded-xl flex items-center justify-center shadow-lg">
                <span class="text-white font-bold text-lg">E</span>
              </div>
              <span class="text-xl font-bold text-foreground">Ember Learning</span>
            </div>
          </div>
          <div class="flex items-center space-x-2">
            <Button @variant="ghost" @class="text-primary">
              Home
            </Button>
            <Button @asChild={{true}} @variant="ghost">
              <:default as |b|>
                <LinkTo @route="demo" class={{b.classes}}>
                  Demo
                </LinkTo>
              </:default>
            </Button>
            <ThemeSwitcher />
          </div>
        </div>
      </div>
    </nav>

    {{! Hero Section }}
    <header class="relative overflow-hidden">
      <div class="absolute inset-0 bg-gradient-to-br from-orange-500/10 via-transparent to-red-500/10"></div>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 relative">
        <div class="text-center max-w-4xl mx-auto">
          <h1 class="text-5xl sm:text-6xl font-extrabold text-foreground mb-6 tracking-tight">
            Learn Modern
            <span class="bg-gradient-to-r from-orange-500 to-red-600 bg-clip-text text-transparent">
              Ember.js
            </span>
          </h1>
          <p class="text-xl text-muted-foreground mb-10 leading-relaxed">
            A hands-on learning project featuring 19 exercises that cover routing, components,
            services, testing, and modern Ember patterns with TypeScript and Glint.
          </p>
          <div class="flex flex-wrap justify-center gap-4">
            <Button @asChild={{true}} @size="lg" @class="bg-gradient-to-r from-orange-500 to-red-600 hover:from-orange-600 hover:to-red-700 shadow-lg shadow-orange-500/30 hover:shadow-xl hover:shadow-orange-500/40 transition-all transform hover:-translate-y-0.5">
              <:default as |b|>
                <LinkTo @route="demo" class={{b.classes}}>
                  Try the Demo
                </LinkTo>
              </:default>
            </Button>
            <Button @variant="outline" @size="lg" @class="shadow-sm">
              <a
                href={{links.github}}
                target="_blank"
                rel="noopener noreferrer"
              >
                View on GitHub
              </a>
            </Button>
          </div>
        </div>
      </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      {{! Tech Stack }}
      <section class="mb-20">
        <div class="flex flex-wrap justify-center gap-3">
          {{#each techStack as |tech|}}
            <Badge @variant="outline" @class="px-4 py-2 text-sm">
              {{tech}}
            </Badge>
          {{/each}}
        </div>
      </section>

      {{! Learning Goals }}
      <section class="mb-20">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-foreground mb-4">What You'll Learn</h2>
          <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
            Master modern Ember.js patterns through practical exercises covering these key areas.
          </p>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {{#each learningCategories as |category|}}
            <Card @class="overflow-hidden hover:shadow-lg transition-shadow pt-0">
              <CardHeader @class="{{category.titleBg}} border-b">
                <CardTitle @class="{{category.titleColor}} text-center">
                  {{category.title}}
                </CardTitle>
              </CardHeader>
              <CardContent @class="pt-4">
                <ul class="space-y-2">
                  {{#each category.items as |item|}}
                    <li class="flex items-start text-sm text-muted-foreground">
                      <svg class="w-5 h-5 text-emerald-500 mr-2 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                      </svg>
                      {{item}}
                    </li>
                  {{/each}}
                </ul>
              </CardContent>
            </Card>
          {{/each}}
        </div>
      </section>

      {{! Prerequisites }}
      <section class="mb-20">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-foreground mb-4">Prerequisites</h2>
          <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
            Complete the <a href={{links.emberTutorial}} target="_blank" rel="noopener noreferrer" class="text-primary hover:underline">Ember Tutorial</a> first, then ensure you're familiar with these concepts.
          </p>
        </div>
        <div class="grid md:grid-cols-2 gap-6">
          {{#each prerequisites as |category|}}
            <Card>
              <CardHeader>
                <CardTitle @class="flex items-center gap-3">
                  <span class="w-8 h-8 {{category.iconBg}} rounded-lg flex items-center justify-center">
                    <span class="{{category.iconColor}} font-bold text-sm">{{category.icon}}</span>
                  </span>
                  {{category.title}}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ul class="space-y-2 text-sm">
                  {{#each category.items as |item|}}
                    <li class="flex items-center">
                      <span class="w-1.5 h-1.5 bg-muted-foreground rounded-full mr-3"></span>
                      <a href={{item.url}} target="_blank" rel="noopener noreferrer" class="text-muted-foreground hover:text-primary hover:underline">{{item.label}}</a>
                    </li>
                  {{/each}}
                </ul>
              </CardContent>
            </Card>
          {{/each}}
        </div>
      </section>

      {{! Exercises }}
      <section class="mb-20">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-foreground mb-4">19 Exercises</h2>
          <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
            Progress from basics to advanced patterns with hands-on exercises.
          </p>
        </div>
        <Card @class="overflow-hidden">
          <Table>
            <TableHeader @class="bg-muted/50">
              <TableRow>
                <TableHead @class="w-16">#</TableHead>
                <TableHead>Exercise</TableHead>
                <TableHead>Key Concepts</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {{#each exercises as |exercise|}}
                <TableRow>
                  <TableCell>
                    <Badge @class="bg-gradient-to-br from-orange-500 to-red-600 text-white border-0">
                      {{exercise.number}}
                    </Badge>
                  </TableCell>
                  <TableCell @class="font-medium">
                    <a
                      href="{{links.github}}/blob/main/exercises/{{exercise.number}}-{{exercise.slug}}.md"
                      target="_blank"
                      rel="noopener noreferrer"
                      class="hover:text-primary hover:underline"
                    >
                      {{exercise.title}}
                    </a>
                  </TableCell>
                  <TableCell @class="text-muted-foreground">
                    {{exercise.concepts}}
                  </TableCell>
                </TableRow>
              {{/each}}
            </TableBody>
          </Table>
        </Card>
      </section>

    </main>

    {{! Footer }}
    <footer class="bg-card border-t">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Separator @class="mb-6" />
        <p class="text-center text-muted-foreground text-sm">
          Built with Ember.js, TypeScript, Glint, Tailwind CSS, and ember-concurrency
        </p>
      </div>
    </footer>
  </div>
</template>
